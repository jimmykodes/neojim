local root_files = {
	".yamlrc",
	".yamlrc.json",
	".git"
}

local M = {
	---@type FTOpts
	opts = {
		ft = "yaml",
		lsp_clients = {
			{
				name = "yamlls",
				cmd = { "yaml-language-server", "--stdio" },
				filetypes = { 'yaml' },
				root_dir = vim.fs.root(0, root_files),
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
		},
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
