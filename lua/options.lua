vim.jumpoptions = "stack" -- use jumplist stack behavior (default: "")

local opt = vim.opt

-- use system clipboard (default: "")
opt.clipboard = "unnamedplus"
opt.cursorline = true

-- read .vimrc in current directory (default: false)
opt.exrc = true
opt.fileencoding = "utf-8"

-- hide end of buffer tildes (default: "~")
opt.fillchars.eob = " "
opt.ignorecase = true
-- treat hyphen as part of word (default doesn't include -)
opt.iskeyword:append "-"
-- global statusline - always include a status line, and only on the last window (default: 2)
opt.laststatus = 3
-- wrap at word boundaries (default: false)
opt.linebreak = true

opt.mouse = "a"
opt.number = true
-- width of number column (default: 4)
opt.numberwidth = 4
opt.relativenumber = true

-- hide cursor position in statusline (default: true)
opt.ruler = false
-- keep 8 lines above/below cursor (default: 0)
opt.scrolloff = 8
-- keep 8 columns left/right of cursor (default: 0)
opt.sidescrolloff = 8

-- remember marks for 500 files (default: '100)
opt.shada:append({ "'500" })
opt.shiftwidth = 2
-- shorten write and search messages
opt.shortmess:append { w = true, s = true }
-- don't show partial commands (default: true)
opt.showcmd = false
-- don't show mode in command line (default: true)
opt.showmode = false
-- always show tabline (default: 1)
opt.showtabline = 2
opt.smartcase = true
opt.smartindent = true
-- new horizontal splits below (default: false)
opt.splitbelow = true
-- new vertical splits to right (default: false)
opt.splitright = true
opt.swapfile = false
opt.tabstop = 2
-- enable 24-bit RGB colors (default: false)
opt.termguicolors = true
-- time to wait for mapped sequence (default: 1000ms)
opt.timeoutlen = 500
-- persistent undo (default: false)
opt.undofile = true
-- time before swap write/CursorHold (default: 4000ms)
opt.updatetime = 500
-- allow cursor wrap with these keys (default: "b,s")
opt.whichwrap:append "<,>,[,],h,l"
-- rounded window borders (default: none)
opt.winborder = 'rounded'
opt.writebackup = false

opt.statusline = "%!v:lua.require'statusline'.status()"
opt.tabline = "%!v:lua.require'statusline'.tab()"
