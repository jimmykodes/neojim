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
}

function M.setup()
	for _, cmd in ipairs(M.cmds) do
		vim.cmd(cmd)
	end
end

return M
