local M = {}

---@class Fmt
---@field event string
---@field callback function

---@class FTOpts
---@field ft string
---@field lsps LSPEntry[]?
---@field lsp_clients vim.lsp.ClientConfig[]?
---@field keymap Keymap?
---@field keymap_opts KeymapOpts?
---@field once function?
---@field setup function?
---@field autocmds AutocmdDef[]?
---@field formatters string[][]?
---@field lint Lint?

---@param cmd string[]
---@param input string
---@return string
local function run_format(cmd, input)
	local output = vim.system(cmd, { stdin = input }):wait()
	return vim.trim(output.stdout)
end

local function format(formatters)
	return function()
		local data = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
		for _, fmt in ipairs(formatters) do
			data = run_format(fmt, data)
		end
		if #data == 0 then
			return
		end
		vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(data, "\n"))
	end
end

---@param opts FTOpts
local function once(opts)
	if vim.g[opts.ft .. "_setup"] then
		return
	end

	if opts.autocmds then
		require('autocmds').define_autocmds(opts.autocmds)
	end

	if opts.formatters ~= nil and #opts.formatters > 0 then
		require('autocmds').define_autocmds({
			{
				event = "BufWritePre",
				opts = {
					pattern = "*." .. opts.ft,
					group = "UserFormatOnSave",
					callback = format(opts.formatters),
				}
			}
		})
	end

	if opts.lint ~= nil then
		local ns_id = vim.api.nvim_create_namespace(opts.lint.name)
		require('autocmds').define_autocmds({
			{
				event = "BufWritePost",
				opts = {
					pattern = "*." .. opts.ft,
					group = "UserLint",
					callback = function(args)
						require('lint').lint(ns_id, opts.lint, args)
					end,
				},
			},
		})
	end


	if opts.lsps then
		require('lsps').setup_lsps(opts.lsps)
	end

	if opts.once ~= nil then
		opts.once()
	end

	vim.g[opts.ft .. "_setup"] = 1
end


---@param opts FTOpts
local function _setup(opts)
	if opts.keymap ~= nil then
		require("keymaps").register_mappings(opts.keymap, opts.keymap_opts)
	end

	if opts.lsp_clients then
		for _, conf in ipairs(opts.lsp_clients) do
			require("lsps").start_lsp(conf)
		end
	end

	if opts.setup ~= nil then
		opts.setup()
	end
	once(opts)

	vim.keymap.set("n", "grf", format(opts.formatters), { buffer = true, desc = "ft format" })
end

---@param opts FTOpts
---@param user_opts FTOpts?
function M.setup(opts, user_opts)
	_setup(vim.tbl_extend("force", opts, user_opts or {}))
end

return M
