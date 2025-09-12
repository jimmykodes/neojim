local M = {
	---@type FTOpts
	opts = {
		ft = "py",
		formatters = {
			{ "autopep8", "-" },
			{ "isort",    "-" },
		},
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
