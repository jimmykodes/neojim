local icons = require('icons')

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
}
