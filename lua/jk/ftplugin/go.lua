local M = {}

local severities = {
	error = vim.diagnostic.severity.ERROR,
	warning = vim.diagnostic.severity.WARN,
	refactor = vim.diagnostic.severity.INFO,
	convention = vim.diagnostic.severity.HINT,
}

---parse string output to vim diagnostics
---@type Parser
function M.parser(output, filename, cwd)
	if output == '' then
		vim.schedule(function()
			vim.notify("no output to parse")
		end)
		return {}
	end
	local decoded = vim.json.decode(output)
	if decoded["Issues"] == nil or type(decoded["Issues"]) == 'userdata' then
		vim.schedule(function()
			vim.notify("no issues to parse")
		end)
		return {}
	end
	local diagnostics = {}

	for _, item in ipairs(decoded["Issues"]) do
		-- normalize the absolute path to the filename
		local filename_norm = vim.fs.normalize(vim.fn.fnamemodify(filename, ":p"))

		-- append the item filename to cwd and get the abspath
		local lintedfile_abs = vim.fn.fnamemodify(cwd .. "/" .. item.Pos.Filename, ":p")
		-- normalize the above abspath
		local lintedfile_norm = vim.fs.normalize(lintedfile_abs)

		-- check if the normalized filename matches the filename in the warning,
		-- or if that normalized filename matches the item position file relative
		-- to cwd.
		if filename_norm == item.Pos.Filename or filename_norm == lintedfile_norm then
			-- only publish if those are the current file diagnostics
			local sv = severities[item.Severity] or severities.warning
			table.insert(diagnostics, {
				lnum = item.Pos.Line > 0 and item.Pos.Line - 1 or 0,
				col = item.Pos.Column > 0 and item.Pos.Column - 1 or 0,
				end_lnum = item.Pos.Line > 0 and item.Pos.Line - 1 or 0,
				end_col = item.Pos.Column > 0 and item.Pos.Column - 1 or 0,
				severity = sv,
				source = item.FromLinter,
				message = item.Text,
			})
		end
	end
	return diagnostics
end

--- Run golangci-lint on the file
---@type Linter
function M.golangcilint(bufnr)
	local filename = vim.fn.bufname(bufnr)
	local cwd = vim.fn.fnamemodify(filename, ":h")

	local cmd = "golangci-lint"
	if vim.g.golangci_lint_override then
		-- allow local ftplugins to point to a different
		-- golangci-lint path
		cmd = vim.g.golangci_lint_override
	end

	return {
		cmd,
		'run',
		'--output.json.path=stdout',
		-- Overwrite values possibly set in .golangci.yml
		'--output.text.path=',
		'--output.tab.path=',
		'--output.html.path=',
		'--output.checkstyle.path=',
		'--output.code-climate.path=',
		'--output.junit-xml.path=',
		'--output.teamcity.path=',
		'--output.sarif.path=',
		'--issues-exit-code=0',
		'--show-stats=false',
		cwd,
	}
end

local function qftests(pkg, test)
	local text = true
	local cmd = { "go", "test" }
	if pkg then
		text = false
		vim.list_extend(cmd, { pkg })
		if test then
			vim.list_extend(cmd, { "-run", test })
		end
	else
		vim.list_extend(cmd, { "-json", "./..." })
	end
	vim.list_extend(cmd, { "2>&1" })

	local output = vim.system(cmd, { text = text }):wait()
	-- local output = vim.fn.system('go test -json ./... 2>&1')
	local qf_list = {}

	if not text then
		return output.code
	end

	for line in output.stdout:gmatch("[^\n]+") do
		local json_ok, parsed = pcall(vim.fn.json_decode, line)
		if json_ok and parsed.Action == "fail" and parsed.Test then
			table.insert(qf_list, {
				filename = parsed.Package .. '/' or "",
				context = parsed.Test,
				text = string.format("FAIL: %s", parsed.Test)
			})
		end
	end

	if #qf_list == 0 then
		vim.notify("All tests passed", vim.log.levels.INFO)
	else
		vim.api.nvim_create_autocmd("BufReadPost", {
			pattern = "quickfix",
			callback = function()
				vim.keymap.set("n", "r", function()
						local qf_idx = vim.fn.line(".")
						local item = qf_list[qf_idx]
						local code = qftests(item.filename, item.context)
						if code == 0 then
							table.remove(qf_list, qf_idx)
							vim.fn.setqflist(qf_list, 'r')
						end
					end,
					{ buffer = true })
			end
		})

		vim.fn.setqflist(qf_list)
		vim.cmd('copen')
	end
end

---@type FTOpts
M.opts = {
	ft = "go",
	keymap = {
		n = {
			["<localleader>"] = {
				e = ':GoIfErr<CR>',
				E = [[:GoIfErr<CR>k_vg_"exdd0Ea err := ;<ESC>"eP]], -- if _, err := call(..); err != nil
				I = [[yiwO = (*<C-r>")(nil)<ESC>0ivar _ ]],     -- var _ {cursor} = (*{struct ident})(nil)
				c = ':GoCmt<CR>',
				t = {
					a = ':GoTagAdd<CR>',
					r = ':GoTagRm<CR>',
					c = function()
						vim.ui.input({ prompt = "Add Tag Name" }, function(input)
							require("gopher.struct_tags").add({ tags = { input } })
						end)
					end,
					C = function()
						vim.ui.input({ prompt = "Remove Tag Name" }, function(input)
							require("gopher.struct_tags").remove({ tags = { input } })
						end)
					end

				},
				T = qftests,
				m = {
					t = ':GoMod tidy<CR>',
					i = ':GoMod init<CR>',
					v = ':GoMod vendor<CR>',
					d = ':GoMod download<CR>',
				},
				i = {
					['.'] = ':!go install .<CR>',
					c = ':!go install ./cmd/...<CR>'
				},
				b = {
					['.'] = ':!go build  .<CR>',
					c = ':!go build ./cmd/...<CR>',
				},
				r = {
					['.'] = ':!go run .<CR>',
					m = ':!go run main.go<CR>',
					f = function()
						vim.ui.input({ prompt = "File:" }, function(file)
							vim.cmd(':!go run ' .. file)
						end)
					end
				}
			}
		}
	},
	keymap_opts = {
		buffer = true,
		noremap = true,
		silent = true,
	},
	once = function()
		require("gopher").setup({})
	end,
	formatters = {
		{ "gofumpt" },
		{ "goimports" },
	},
	lint = {
		name = "golangci-lint",
		parser = M.parser,
		cmd = M.golangcilint
	}
}


---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
