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
				cmd = { "lua-language-server" },
				filetypes = { 'lua' },
				root_dir = vim.fs.root(0, root_files),
				log_level = vim.lsp.protocol.MessageType.Warning,
				settings = { Lua = vim.empty_dict() },
			}
		}
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
