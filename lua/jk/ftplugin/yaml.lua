local root_files = {
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
					-- TODO: do i need this?
					-- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
					redhat = { telemetry = { enabled = false } }
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
