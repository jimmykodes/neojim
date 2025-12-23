local M = {
	cmds = {
		[[
		function! QuickFixToggle()
			if empty(filter(getwininfo(), 'v:val.quickfix'))
				copen
			else
				cclose
			endif
		endfunction
		]],
	},
	lua = {
		["Date"] = function()
			local date = os.date('%Y-%m-%d')
			vim.api.nvim_put({ date }, 'c', true, true)
		end,
	}
}

function M.setup()
	for _, cmd in ipairs(M.cmds) do
		vim.cmd(cmd)
	end
	for cmd, body in pairs(M.lua) do
		vim.api.nvim_create_user_command(cmd, body, {})
	end
end

return M
