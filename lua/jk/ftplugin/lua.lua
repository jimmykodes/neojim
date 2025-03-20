local root_files = {
	'.luarc.json',
	'.luarc.jsonc',
	'.luacheckrc',
	'.stylua.toml',
	'stylua.toml',
	'selene.toml',
	'selene.yml',
	".git",
}

local M = {
	---@type FTOpts
	opts = {
		ft = "lua",
		lsp_clients = {
			{
				name = "lua_ls",
				cmd = { 'lua-language-server' },
				filetypes = { 'lua' },
				root_dir = vim.fs.root(0, root_files),
				log_level = vim.lsp.protocol.MessageType.Warning,
			}
		}
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(vim.tbl_extend("force", M.opts, opts or {}))
end

return M
