---@type vim.lsp.Config
return {
	name = "rust_analyzer",
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = {
		"Cargo.toml",
		"rust-project.json",
	},
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
			procMacro = {
				enable = true,
			},
			diagnostics = {
				enable = true,
				experimental = {
					enable = true,
				},
			},
		},
	},
}
