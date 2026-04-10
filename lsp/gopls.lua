---@type vim.lsp.Config
return {
	name = "gopls",
	cmd = { "gopls" },
	filetypes = { "go", "gotmpl", "gomod", "gowork" },
	settings = {
		gopls = {
			hints = { parameterNames = true, functionTypeParameters = true },
			semanticTokens = true,
		}
	},
	root_markers = {
		"go.work",
		"go.mod",
		"main.go",
	},
}
