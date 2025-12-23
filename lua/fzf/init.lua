local fzf = require("fzf-lua")

local function withops(f, ...)
	f(...)
end

local M = {
	buffers = fzf.buffers,
	files = fzf.files,
	find_text = fzf.live_grep,
	oldfiles = fzf.oldfiles,
	resume = fzf.resume,
	diag_doc = fzf.diagnostics_document,
	diag_work = fzf.diagnostics_workspace,
	commands = fzf.commands,
	lsp_document_symbols = fzf.lsp_document_symbols,
}


return M
