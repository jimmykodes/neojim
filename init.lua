vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("jk.autocmds").setup()
require("jk.options").setup()
require("jk.commands").setup()
require("jk.plugins").setup()
require("jk.keymaps").setup()
require("jk.lsps").setup()
require("jk.color").setup()
