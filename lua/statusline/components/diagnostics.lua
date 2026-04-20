local icons = require "icons"

local hls = {
	[vim.diagnostic.severity.ERROR] = "DiagnosticError",
	[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
	[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
	[vim.diagnostic.severity.HINT] = "DiagnosticHint",
}
local severity_icons = {
	[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
	[vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
	[vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
	[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
}

local function fmt(hl, icon, count)
	return string.format("%%#%s#%s %d", hl, icon, count)
end

return {
	show = function() return not vim.tbl_isempty(vim.diagnostic.count(0)) end,
	render = function()
		local counts = vim.diagnostic.count(0)
		local out = {}
		for severity, count in pairs(counts) do
			table.insert(out, fmt(hls[severity], severity_icons[severity], count))
		end
		return table.concat(out, " ")
	end,
}
