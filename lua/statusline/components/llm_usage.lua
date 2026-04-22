local icons = require('icons')
local utils = require('statusline.utils')

local function contextUsage(p)
	local blocks = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
	local hl = { 'Success', 'Success', 'Success', 'Warning', 'Warning', 'Warning', 'Error', 'Error' }
	local i = math.floor(p * #blocks) + 1
	return {
		char = blocks[math.min(i, #blocks)],
		hl = hl[math.min(i, #hl)],
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

		---@type Metadata
		local meta = llima.metadata()
		local str = ""
		if meta.is_ephemeral or meta.name == nil then
			str = icons.misc.Watch .. " - "
		else
			str = string.format("%s %s - ", icons.ui.Forum, meta.name)
		end

		local ctxUsage = contextUsage(meta.context_usage or 0)

		---@type Usage
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
			utils.renderComponent(utils.simple_module(ctxUsage.char, ctxUsage.hl))
		)
	end
}
