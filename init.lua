vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("options")
require("commands")
require("filtetypes")

require("autocmds").setup()
require("plugins").setup()
require("treesitter").setup()
require("keymaps").setup()
require("lsps").setup()

vim.cmd.colorscheme("system76")
