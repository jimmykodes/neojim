local M = {
	opts = {}
}

function M.setup()
	require("gitsigns").setup(M.opts)
end

return M
