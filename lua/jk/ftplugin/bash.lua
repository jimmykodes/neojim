local M = {
	---@type FTOpts
	opts = {
		ft = "bash",
		---@type vim.lsp.ClientConfig[]
		lsp_clients = {
			{
				name = "bashls",
				cmd = { 'bash-language-server', 'start' },
				settings = {
					bashIde = {
						-- Glob pattern for finding and parsing shell script files in the workspace.
						-- Used by the background analysis features across files.

						-- Prevent recursive scanning which will cause issues when opening a file
						-- directly in the home directory (e.g. ~/foo.sh).
						--
						-- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command|.zsh)".
						globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command|.zsh)',
					},
				},
				filetypes = { 'bash', 'sh', 'zsh' },
				root_dir = vim.fs.root(0, { '.git' }),
				-- TODO: what does this do?
				single_file_support = true,
			},
		}
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(vim.tbl_extend("force", M.opts, opts or {}))
end

return M
