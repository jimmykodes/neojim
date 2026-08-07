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

vim.api.nvim_create_autocmd("User", {
	pattern = "LlimaMetadataChange",
	callback = utils.redraw,
})


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
		local with_icon = function(icon, digit)
			return string.format("%s %d", icon, digit)
		end
		local usage_str = string.format(
			"%s %s %s %s",
			with_icon(icons.ui.SignIn, usage.cache_creation_input_tokens or 0),
			with_icon(icons.ui.SignOut, usage.cache_read_input_tokens or 0),
			with_icon(icons.ui.BoldArrowUp, usage.input_tokens or 0),
			with_icon(icons.ui.BoldArrowDown, usage.output_tokens or 0)
		)
		local cache_hl = "StatusLineSuccess"
		if not llima.cache_enabled() then
			cache_hl = "StatusLineWarning"
		end
		return str .. string.format(
			"%s %s - %s %s $%0.2f %s %s",
			icons.misc.Robot,
			meta.model,
			icons.ui.Ticket,
			usage_str,
			(meta.cost or 0) / 100,
			utils.renderComponent(utils.simple_module(ctxUsage.bar, ctxUsage.hl)),
			utils.renderComponent(utils.bubble(utils.simple_module(icons.ui.Database, cache_hl)))
		)
	end
}
