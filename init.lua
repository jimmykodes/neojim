vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("options")
require("commands")
require("filtetypes")
require("plugins")
require("treesitter")

-- Goal: eventually refactor this to get rid of the need
-- for a setup function
require("autocmds").setup()
require("keymaps").setup()
require("lsps").setup()

vim.cmd.colorscheme("system76")
