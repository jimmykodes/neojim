vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("options")
require("commands")
require("filtetypes")
require("plugins")
require("treesitter")
require("completion")

-- Goal: eventually refactor this to get rid of the need
-- for a setup function
require("autocmds").setup()
require("keymaps").setup()
require("lsps").setup()

vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "background",
	callback = function()
		if vim.o.background == "dark" then
			vim.cmd.colorscheme("system76")
		else
			vim.cmd.colorscheme("system67")
		end
	end,
})

vim.api.nvim_create_autocmd("FocusGained", {
	callback = function() vim.cmd("silent! doautocmd OptionSet background") end,
})
