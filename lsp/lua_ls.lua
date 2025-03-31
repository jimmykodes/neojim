---@type vim.lsp.Config
return {
	name = "lua_ls",
	cmd = { "lua-language-server" },
	filetypes = { 'lua' },
	root_markers = {
		'.luarc.json',
		'.luarc.jsonc',
		'.luacheckrc',
		'.stylua.toml',
		'stylua.toml',
		'selene.toml',
		'selene.yml',
	},
	settings = { Lua = vim.empty_dict() },
}
