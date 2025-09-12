local M = {
	---@type FTOpts
	opts = {
		ft = "json",
		formatters = {
			{ "jq", "." },
		}
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
