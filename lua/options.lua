vim.jumpoptions = "stack" -- use jumplist stack behavior (default: "")

local opt = vim.opt

opt.clipboard = "unnamedplus" -- use system clipboard (default: "")
opt.cursorline = true
opt.exrc = true               -- read .vimrc in current directory (default: false)
opt.fileencoding = "utf-8"
opt.fillchars.eob = " "       -- hide end of buffer tildes (default: "~")
opt.ignorecase = true
opt.iskeyword:append "-"      -- treat hyphen as part of word (default doesn't include -)
opt.laststatus = 3            -- global statusline - always include a status line, and only on the last window (default: 2)
opt.linebreak = true          -- wrap at word boundaries (default: false)
opt.mouse = "a"
opt.number = true
opt.numberwidth = 4                         -- width of number column (default: 4)
opt.relativenumber = true
opt.ruler = false                           -- hide cursor position in statusline (default: true)
opt.scrolloff = 8                           -- keep 8 lines above/below cursor (default: 0)
opt.shada:append({ "'500" })                -- remember marks for 500 files (default: '100)
opt.shiftwidth = 2
opt.shortmess:append { w = true, s = true } -- shorten write and search messages
opt.showcmd = false                         -- don't show partial commands (default: true)
opt.showmode = false                        -- don't show mode in command line (default: true)
opt.showtabline = 2                         -- always show tabline (default: 1)
opt.sidescrolloff = 8                       -- keep 8 columns left/right of cursor (default: 0)
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true -- new horizontal splits below (default: false)
opt.splitright = true -- new vertical splits to right (default: false)
opt.swapfile = false
opt.tabstop = 2
opt.termguicolors = true           -- enable 24-bit RGB colors (default: false)
opt.timeoutlen = 500               -- time to wait for mapped sequence (default: 1000ms)
opt.undofile = true                -- persistent undo (default: false)
opt.updatetime = 300               -- time before swap write/CursorHold (default: 4000ms)
opt.whichwrap:append "<,>,[,],h,l" -- allow cursor wrap with these keys (default: "b,s")
opt.winborder = 'rounded'          -- rounded window borders (default: none)
opt.writebackup = false
