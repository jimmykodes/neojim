local M = {
	---@type FTOpts
	opts = { ft = "typescript" }
}

---@param opts FTOpts?
function M.setup(opts)
	require('ft').setup(M.opts, opts)
end

return M
