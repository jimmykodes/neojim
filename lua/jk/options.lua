local M = {}

function M.setup()
	local opt = vim.opt

	opt.clipboard = "unnamedplus"
	opt.cmdheight = 2
	opt.fileencoding = "utf-8"
	opt.ignorecase = true
	opt.mouse = "a"
	opt.showmode = false
	opt.showtabline = 2
	opt.smartcase = true
	opt.smartindent = true
	opt.splitbelow = true
	opt.splitright = true
	opt.swapfile = false
	opt.termguicolors = true
	opt.timeoutlen = 300
	opt.undofile = true
	opt.updatetime = 300
	opt.writebackup = false
	opt.tabstop = 2
	opt.shiftwidth = 2
	opt.cursorline = true
	opt.number = true
	opt.relativenumber = true
	opt.laststatus = 3
	opt.showcmd = false
	opt.ruler = false
	opt.numberwidth = 4
	opt.scrolloff = 8
	opt.sidescrolloff = 8
	opt.guifont = "monospace:h17"
	opt.fillchars.eob = " "
	opt.shortmess:append "c"
	opt.whichwrap:append "<,>,[,],h,l"
	opt.iskeyword:append "-"
	opt.formatoptions:remove { "c", "r", "o" }
	opt.linebreak = true
end

return M
