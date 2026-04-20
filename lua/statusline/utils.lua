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

function M.simple_module(text)
	return {
		show = M.always,
		hl = function() return "StatusLine" end,
		render = function() return text end,
	}
end

return M
