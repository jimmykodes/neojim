local root_files = {
	"Dockerfile",
	".git"
}

local M = {
	---@type FTOpts
	opts = {
		ft = "dockerfile",
		lsp_clients = {
			{
				name = "dockerls",
				cmd = { "docker-langserver", "--stdio" },
				root_dir = vim.fs.root(0, root_files)
			}
		},
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
