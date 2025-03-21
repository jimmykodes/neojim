local root_files = {
	"Chart.yaml",
	".git"
}

local M = {
	---@type FTOpts
	opts = {
		ft = "helm",
		lsp_clients = {
			{
				name = "helm_ls",
				cmd = { "helm_ls", "serve" },
				filetypes = { "helm" },
				root_dir = vim.fs.root(0, root_files),
				capabilities = {
					workspace = {
						didChangeWatchedFiles = {
							dynamicRegistration = true,
						},
					},
				},
			}
		},
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
