local M = {}

function M.setup()
	vim.jumpoptions = "stack"

	local opt = vim.opt

	opt.clipboard = "unnamedplus"
	opt.cmdheight = 2
	opt.cursorline = true
	opt.exrc = true
	opt.fileencoding = "utf-8"
	opt.fillchars.eob = " "
	opt.formatoptions:remove { "c", "r", "o" }
	opt.guifont = "monospace:h17"
	opt.ignorecase = true
	opt.iskeyword:append "-"
	opt.laststatus = 3
	opt.linebreak = true
	opt.mouse = "a"
	opt.number = true
	opt.numberwidth = 4
	opt.relativenumber = true
	opt.ruler = false
	opt.scrolloff = 8
	opt.shada:append({ "'500" })
	opt.shiftwidth = 2
	opt.shortmess:append "c"
	opt.showcmd = false
	opt.showmode = false
	opt.showtabline = 2
	opt.sidescrolloff = 8
	opt.smartcase = true
	opt.smartindent = true
	opt.splitbelow = true
	opt.splitright = true
	opt.swapfile = false
	opt.tabstop = 2
	opt.termguicolors = true
	opt.timeoutlen = 800
	opt.undofile = true
	opt.updatetime = 300
	opt.whichwrap:append "<,>,[,],h,l"
	opt.winborder = 'rounded'
	opt.writebackup = false
end

return M
