local root_files = {
	"docker-compose.yaml",
	"docker-compose.yml",
	"compose.yaml",
	"compose.yml",
	".git"
}

local M = {
	---@type FTOpts
	opts = {
		ft = "yaml.docker-compose",
		lsp_clients = {
			{
				name = "dc_ls",
				cmd = { "docker-compose-langserver", '--stdio' },
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
