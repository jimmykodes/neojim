local utils = require "statusline.utils"
local show = false
local number = ""
local state = ""
local decision = ""
local isDraft = false


local function fetch_number()
	vim.system({ "gh", "pr", "view", "--json", "number,state,reviewDecision,isDraft" }, function(resp)
		if resp.code ~= 0 then
			return
		end
		local data = vim.json.decode(resp.stdout)
		number = data.number
		state = data.state
		decision = data.reviewDecision
		isDraft = data.isDraft
		show = true
		utils.redraw()
	end)
end

fetch_number()

return utils.bubble({
	hl = function()
		if state == "OPEN" then
			if isDraft then
				return "StatusLineDull"
			elseif decision == "CHANGES_REQUESTED" then
				return "StatusLineWarning"
			elseif decision == "APPROVED" then
				return "StatusLineSuccess"
			else
				return "StatusLineInfo"
			end
		elseif state == "MERGED" then
			return "StatusLineModeVisual"
		elseif state == "CLOSED" then
			return "StatusLineFailure"
		else
			return "StatusLine"
		end
	end,
	show = function() return show end,
	render = function()
		return "#" .. number
	end
})
