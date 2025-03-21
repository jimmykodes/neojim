local root_files = {
	'pyproject.toml',
	'setup.py',
	'setup.cfg',
	'requirements.txt',
	'Pipfile',
	'pyrightconfig.json',
	'.git',
}

local M = {
	---@type FTOpts
	opts = {
		ft = "python",
		lsp_clients = {
			{
				name = "pyright",
				cmd = { 'pyright-langserver', '--stdio' },
				root_dir = vim.fs.root(0, root_files),
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = 'openFilesOnly',
						}
					}
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
