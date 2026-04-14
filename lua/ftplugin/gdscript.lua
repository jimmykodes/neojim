local root_files = {
	"project.godot",
	".git"
}

local M = {
	---@type FTOpts
	opts = {
		ft = "gdscript",
		lsp_clients = {
			{
				name = "gdscript_ls",
				cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
				root_dir = vim.fs.root(0, root_files),
			}
		},
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
