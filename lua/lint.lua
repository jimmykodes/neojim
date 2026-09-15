---@alias Parser fun(output: string, filename: string, cwd: string): vim.Diagnostic[]
---
---@alias Linter fun(bufnr: integer): string[]

---@class Lint
---@field name string
---@field parser Parser
---@field cmd Linter
---@field additionalValidCodes integer[]?

local M = {}

---@param ns_id integer
---@param lint Lint
---@param args vim.api.keyset.create_autocmd.callback_args
function M.lint(ns_id, lint, args)
	local cmd = lint.cmd(args.buf)
	local filename = vim.fn.bufname(args.buf)
	local cwd = vim.fn.getcwd()
	local expectedCode = lint.additionalValidCodes or {}
	vim.system(cmd, { text = true }, function(out)
		if out.code ~= 0 and not vim.list_contains(expectedCode, out.code) then
			vim.schedule(function()
				vim.notify(
					string.format(
						"%s exited with unexpected code: %d - %s",
						lint.name,
						out.code,
						out.stderr
					),
					vim.log.levels.WARN)
			end)
			return
		end

		local output = vim.trim(out.stdout)
		if output == "" then
			-- clear diags
			vim.schedule(function()
				vim.diagnostic.set(ns_id, args.buf, {}, {
					virtual_text = true, -- show virtual text
					signs = true,        -- show signs in sign column
					underline = true,    -- underline diagnostic text
					update_in_insert = false, -- don't update in insert mode
				})
			end)
		end

		local diags = lint.parser(output, filename, cwd)
		vim.schedule(function()
			vim.diagnostic.set(ns_id, args.buf, diags, {
				virtual_text = true,  -- show virtual text
				signs = true,         -- show signs in sign column
				underline = true,     -- underline diagnostic text
				update_in_insert = false, -- don't update in insert mode
			})
		end)
	end)
end

return M
