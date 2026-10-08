local M = {}

local function hl(group)
	return vim.api.nvim_get_hl(0, {
		name = group,
		link = false,
		create = false,
	})
end

M.base = hl("StatusLine")
M.groups = {
	ModeNormal = { fg = M.base.bg, bg = hl("Constant").fg },
	ModeVisual = { fg = M.base.bg, bg = hl("Keyword").fg },
	ModeCommand = { fg = M.base.bg, bg = hl("Special").fg },
	ModeInsert = { fg = M.base.bg, bg = hl("String").fg },
	ModePending = { fg = M.base.bg, bg = hl("Function").fg },
	ModeReplace = { fg = M.base.bg, bg = hl("Error").fg },

	Dull = { fg = M.base.bg, bg = hl("Comment").fg },
	-- Bold = { fg = M.base.fg, bg = M.base.bg, bold = true },
	-- Dim = { fg = hl("LineNr").fg, bg = M.base.bg },
}
function M.set_hl_groups()
	for group, opts in pairs(M.groups) do
		vim.api.nvim_set_hl(0, "StatusLine" .. group, opts)
		opts.fg, opts.bg = opts.bg, opts.fg
		vim.api.nvim_set_hl(0, "StatusLine" .. group .. "Inverted", opts)
	end
end

return M
