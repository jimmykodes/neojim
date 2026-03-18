local M = require('lualine.component'):extend()

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

	local usage = llima.usage()
	return ("Input Tokens: %d - Output Tokens: %d - Context Usage: %g"):format(
		usage.input_tokens or 0,
		usage.output_tokens or 0,
		(usage.context_used or 0) * 100
	) .. "%%"
end

return M
