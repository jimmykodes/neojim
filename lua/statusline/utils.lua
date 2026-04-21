local M = {}

local default_fts = {
	"checkhealth",
	"DressingInput",
	"mason",
	"NvimTree",
	"qf",
	"toggleterm",
	"alpha",
}

function M.always()
	return true
end

function M.is_ignored_ft(fts)
	local ignored = fts or default_fts
	return vim.list_contains(ignored, vim.bo.filetype)
end

function M.simple_module(text, hl)
	return {
		show = M.always,
		hl = function() return hl or "StatusLine" end,
		render = function() return text end,
	}
end

function M.bubble(component)
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

function M.renderComponent(component)
	if not component.show() then
		return ""
	end

	local out = string.format("%s", component.render())

	local hl = ""
	if component.hl ~= nil then
		hl = component.hl()
	end
	if hl ~= "" then
		out = "%#" .. hl .. "#" .. out
	end

	return out
end

function M.renderAll(componenets)
	return vim.iter(componenets)
			:map(M.renderComponent)
			:join(" ")
end

return M
