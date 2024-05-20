local M = {}

local function _get_color()
	local color = "system76"
	local conf = os.getenv("XDG_CONFIG_HOME")
	if conf == nil then
		return color
	end
	local f = io.open(conf .. "/color", "r")
	if f == nil then
		return color
	end
	color = f:read()
	return color
end

function M.setup()
	local color = _get_color()
	vim.g.colors_name = color
	vim.cmd("colorscheme " .. color)
end

return M
