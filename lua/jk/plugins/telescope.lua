local M = {
	opts = {},
}

function M.setup()
	require('telescope').setup(M.opts)
end

return M
