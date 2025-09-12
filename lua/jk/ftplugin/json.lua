local M = {
	---@type FTOpts
	opts = {
		ft = "json",
		fmt = function()
			local input = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
			local output = vim.system({ "jq", "." }, { stdin = input }):wait()
			vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(vim.trim(output.stdout), "\n"))
		end
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
