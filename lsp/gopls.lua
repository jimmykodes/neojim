---@type vim.lsp.Config
return {
	name = "gopls",
	cmd = { "gopls" },
	filetypes = { "go", "gotmpl", "gomod", "gowork" },
	root_markers = {
		"go.work",
		"go.mod",
		"main.go",
	},
}
