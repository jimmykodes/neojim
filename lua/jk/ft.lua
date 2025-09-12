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
---@field fmt Fmt|function?

---@param opts FTOpts
local function once(opts)
	if vim.g[opts.ft .. "_setup"] then
		return
	end

	if opts.autocmds then
		require('jk.autocmds').define_autocmds(opts.autocmds)
	end

	if opts.fmt ~= nil then
		---@type string
		local event = "BufWritePre"

		---@type function
		local callback

		---@type function|Fmt
		local fmt = opts.fmt

		if type(fmt) == "table" then
			event = fmt.event
			callback = fmt.callback
		elseif type(fmt) == "function" then
			callback = fmt
		end

		require('jk.autocmds').define_autocmds({
			{
				event = event,
				opts = {
					pattern = "*." .. opts.ft,
					group = "UserFormatOnSave",
					callback = callback,
				}
			}
		})
	end


	if opts.lsps then
		require('jk.lsps').setup_lsps(opts.lsps)
	end

	if opts.once ~= nil then
		opts.once()
	end

	vim.g[opts.ft .. "_setup"] = 1
end


---@param opts FTOpts
local function _setup(opts)
	if opts.keymap ~= nil then
		require("jk.keymaps").register_mappings(opts.keymap, opts.keymap_opts)
	end

	if opts.lsp_clients then
		for _, conf in ipairs(opts.lsp_clients) do
			require("jk.lsps").start_lsp(conf)
		end
	end

	if opts.setup ~= nil then
		opts.setup()
	end
	once(opts)

	---@type function
	local callback
	local fmt = opts.fmt
	if fmt == nil then
		callback = function() vim.lsp.buf.format() end
	elseif type(fmt) == "table" then
		callback = fmt.callback
	elseif type(fmt) == "function" then
		callback = fmt
	end

	vim.keymap.set("n", "grf", callback, { buffer = true, desc = "ft format" })
end

---@param opts FTOpts
---@param user_opts FTOpts?
function M.setup(opts, user_opts)
	_setup(vim.tbl_extend("force", opts, user_opts or {}))
end

return M
