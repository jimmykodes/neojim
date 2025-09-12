---@param input string
---@return string
local function isort(input)
	local output = vim.system({ "isort", "-" }, { stdin = input }):wait()
	return vim.trim(output.stdout)
end

---@param input string
---@return string
local function autopep8(input)
	local output = vim.system({ "autopep8", "-" }, { stdin = input }):wait()
	return vim.trim(output.stdout)
end

local M = {
	---@type FTOpts
	opts = {
		ft = "py",
		fmt = function()
			local input = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
			local output = isort(autopep8(input))
			if #output == 0 then
				return
			end
			vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, "\n"))
		end
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
