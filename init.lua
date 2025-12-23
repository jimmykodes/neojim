vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("autocmds").setup()
require("options").setup()
require("commands").setup()
require("plugins").setup()
require("filtetypes").setup()
require("treesitter").setup()
require("keymaps").setup()
require("lsps").setup()
require("color").setup()
