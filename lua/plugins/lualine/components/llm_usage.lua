local M = require('lualine.component'):extend()
local icons = require("icons")

function M:init(options)
	options.component_name = 'usage'
	options.cond = function()
		return vim.bo.filetype == "markdown.llm"
	end

	M.super.init(self, options)
end

function M:update_status(is_focused)
	if not is_focused then
		return ""
	end
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
	local usage = meta.usage or {}
	return str .. string.format(
		"%s %s - %s %s %d %s %d",
		icons.misc.Robot,
		meta.model,
		icons.ui.Ticket,
		icons.ui.BoldArrowUp,
		usage.input_tokens or 0,
		icons.ui.BoldArrowDown,
		usage.output_tokens or 0
	)
end

return M
