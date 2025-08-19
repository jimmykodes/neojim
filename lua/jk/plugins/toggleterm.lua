local M = {
	opts = {
		open_mapping = [[<C-\>]],
		direction = "float",
		float_opts = {
			border = "curved",
		},
	}
}

function M.setup()
	require("toggleterm").setup(M.opts)
end

return M
