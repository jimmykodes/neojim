local M = {
	opts = {
		open_mapping = [[<C-\>]],
		direction = "float",
		float_opts = {
			border = "curved",
		},
	}
}

function M.setup()
	require("toggleterm").setup(M.opts)
	vim.keymap.set('t', '<ESC><ESC>', [[<C-\><C-N>]], { noremap = true })
end

M.k9s = function()
	local Terminal = require("toggleterm.terminal").Terminal
	local term = Terminal:new {
		cmd = "k9s",
		hidden = true,
		direction = "float",
		float_opts = {
			border = "none",
			width = 100000,
			height = 100000,
		},
		on_open = function(_)
			vim.cmd "startinsert!"
		end,
		on_close = function(_) end,
		count = 99,
	}
	term:toggle()
end

M.lazygit = function()
	local Terminal = require("toggleterm.terminal").Terminal
	local term = Terminal:new {
		cmd = "lazygit",
		hidden = true,
		direction = "float",
		float_opts = {
			border = "none",
			width = 100000,
			height = 100000,
		},
		on_open = function(_)
			vim.cmd "startinsert!"
		end,
		on_close = function(_) end,
		count = 99,
	}
	term:toggle()
end

return M
