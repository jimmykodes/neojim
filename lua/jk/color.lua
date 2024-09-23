local M = {}

function M.setup()
	local color = "system76"
	vim.g.colors_name = color
	vim.cmd("colorscheme " .. color)
end

return M
