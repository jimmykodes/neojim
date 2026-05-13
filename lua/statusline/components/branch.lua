local icons = require "icons"
local utils = require "statusline.utils"
local show = false
local branch = ""

vim.system({ "git", "branch", "--show-current" }, function(resp)
	if resp.code ~= 0 then
		return
	end
	show = true
	branch = vim.trim(resp.stdout)
	utils.redraw()
end)



return {
	hl = function() return "StatusLineSuccessInverted" end,
	show = function()
		return show
	end,
	render = function() return icons.git.Branch .. " " .. branch end
}
