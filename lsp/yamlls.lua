return {
	name = "yamlls",
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { 'yaml' },
	root_markers = {
		".yamlrc",
		".yamlrc.json",
	},
	settings = {
		-- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
		redhat = { telemetry = { enabled = false } },
		yaml = {
			schemas = {
				["schema.json"] = "recipes/*.yaml"
			},
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},
			-- Enable schema search in root directory
			schemaDownload = { enable = true },

			-- Explicitly tell yamlls to look for these config files
			schemaStoreLoadFromDisk = true,
		},
	}
}
