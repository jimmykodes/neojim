local root_files = {
	".git"
}

local M = {
	---@type FTOpts
	opts = {
		ft = "json",
		lsp_clients = {
			{
				name = "json_ls",
				cmd = { 'vscode-json-language-server', '--stdio' },
				filetypes = { 'json', 'jsonc' },
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
