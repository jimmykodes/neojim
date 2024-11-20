local M = {}

function M.setup()
	-- local color = "system76"
	local color = "pokemon"
	vim.g.colors_name = color
	vim.cmd("colorscheme " .. color)
end

return M
