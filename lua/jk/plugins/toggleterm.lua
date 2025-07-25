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
end

M.llm = function()
	local Terminal = require("toggleterm.terminal").Terminal
	vim.ui.input({ prompt = "chat name" }, function(name)
		local cmd = "llm t chat"
		if name ~= "" then
			cmd = string.format("%s --new %s", cmd, name)
			return
		end
		Terminal:new({
			cmd = cmd,
			hidden = false,
			on_open = function(_)
				vim.cmd "startinsert!"
			end,
			on_close = function(_) end,
			count = 99,
		}):toggle(20, "horizontal")
	end)
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
