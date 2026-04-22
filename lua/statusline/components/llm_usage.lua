local icons = require('icons')
local utils = require('statusline.utils')

local function contextUsage(p)
	local partial = { '▏', '▎', '▍', '▌', '▋', '▊', '▉', '█' }
	local num_chars = 3
	local total_steps = num_chars * (#partial - 1)
	local step = math.floor(p * total_steps) + 1

	local bar = ""
	local hl
	if step < #partial then
		hl = 'Success'
		bar = partial[step] .. " " .. " "
	elseif step - #partial < #partial then
		hl = 'Warning'
		bar = '█' .. partial[step - #partial] .. " "
	else
		hl = 'Error'
		bar = '██' .. partial[step - #partial - #partial]
	end

	return {
		bar = bar .. '▏' .. string.format("%0.0f%%%%", p * 100),
		hl = hl,
	}
end

return {
	hl = function() return "StatusLine" end,
	show = function()
		return vim.bo.filetype == "markdown.llm"
	end,
	render = function()
		local ok, llima = pcall(require, "llima")
		if not ok then
			return ""
		end

		local meta = llima.metadata()
		local str = ""
		if meta.is_ephemeral or meta.name == nil then
			str = icons.misc.Watch .. " - "
		else
			str = string.format("%s %s - ", icons.ui.Forum, meta.name)
		end

		local ctxUsage = contextUsage(meta.context_usage or 0)

		local usage = meta.usage or {}
		return str .. string.format(
			"%s %s - %s %s %d %s %d %s",
			icons.misc.Robot,
			meta.model,
			icons.ui.Ticket,
			icons.ui.BoldArrowUp,
			usage.input_tokens or 0,
			icons.ui.BoldArrowDown,
			usage.output_tokens or 0,
			utils.renderComponent(utils.simple_module(ctxUsage.bar, ctxUsage.hl))
		)
	end
}
