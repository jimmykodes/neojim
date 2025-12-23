local root_files = {
	".terraform",
	".git"
}

local M = {
	---@type FTOpts
	opts = {
		ft = "terraform",
		lsp_clients = {
			{
				name = "terraform_ls",
				cmd = { 'terraform-ls', 'serve' },
				filetypes = { 'terraform' },
				root_dir = vim.fs.root(0, root_files)
			}
		},
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('ft').setup(M.opts, opts)
end

return M
