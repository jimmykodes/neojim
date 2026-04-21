local utils = require "statusline.utils"

local buffer = {
	hl = function() return "StatusLineInfo" end,
	show = function()
		return vim.api.nvim_buf_get_name(0) ~= ""
	end,
	render = function()
		local buf = 0
		return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
	end
}

local altbuf = {
	hl = function() return "StatusLineInfoInverted" end,
	show = function() return vim.fn.bufnr('#') >= 0 end,
	render = function()
		local buf = vim.fn.bufnr('#')
		return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
	end
}

local bufcount = {
	hl = function() return "StatusLine" end,
	show = function() return true end,
	render = function()
		local count = vim.iter(vim.api.nvim_list_bufs())
				:filter(function(bufnr) return vim.fn.buflisted(bufnr) > 0 end)
				:fold(0, function(acc) return acc + 1 end)
		if altbuf.show() then
			-- remove the altbuf from count
			count = count - 1
		end
		if buffer.show() then
			-- remove the active buf from count
			count = count - 1
		end
		if count > 0 then
			return string.format("+%d", count)
		end
		return ""
	end
}

return {
	show = utils.always,
	render = function()
		return utils.renderAll({
			utils.bubble(buffer),
			altbuf,
			bufcount,
		})
	end
}
