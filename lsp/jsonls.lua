---@type vim.lsp.Config
return {
	name = "jsonls",
	cmd = { 'vscode-json-language-server', '--stdio' },
	filetypes = { 'json', 'jsonc' },
}
