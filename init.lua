vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("jk.autocmds").setup()
require("jk.options").setup()
require("jk.commands").setup()
require("jk.plugins").setup()
require("jk.keymaps").setup()
require("jk.lsps").setup()
require("jk.color").setup()
