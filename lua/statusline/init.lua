local utils = require "statusline.utils"
local lr_sep = "%=%#StatusLine#"

local M = {}


local function bubble(component)
	return {
		show = component.show,
		hl = function() return "" end,
		render = function()
			local text = component.render()
			local hl = component.hl()
			return table.concat({
				"%#" .. hl .. "Inverted" .. "#",
				"%#" .. hl .. "#" .. " " .. text .. " ",
				"%#" .. hl .. "Inverted" .. "#",
			})
		end
	}
end

local function render(component)
	if not component.show() then
		return ""
	end

	local out = string.format(" %s ", component.render())

	local hl = ""
	if component.hl ~= nil then
		hl = component.hl()
	end
	if hl ~= "" then
		out = "%#" .. hl .. "#" .. out
	end

	return out
end

function M.left()
	return {
		bubble(require('statusline.components.mode')),
		require('statusline.components.branch'),
		require('statusline.components.diagnostics'),
		require('statusline.components.llm_usage'),
	}
end

function M.right()
	return {
		require('statusline.components.languages'),
		utils.simple_module(vim.bo.filetype),
		bubble(require('statusline.components.lsp')),
	}
end

function M.render()
	local content = {}

	vim.list_extend(content, vim.iter(M.left()):map(render):totable())
	vim.list_extend(content, { lr_sep })
	vim.list_extend(content, vim.iter(M.right()):map(render):totable())
	return table.concat(content)
end

return M
