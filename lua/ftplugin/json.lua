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
	require('ft').setup(M.opts, opts)
end

return M
