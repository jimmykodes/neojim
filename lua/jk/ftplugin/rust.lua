local M = {
	---@type FTOpts
	opts = {
		ft = "rs",
		formatters = {
			{ "rustfmt" },
		},
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
