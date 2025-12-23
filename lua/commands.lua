---@class UserCommand
---@field name string
---@field command string|fun(args: vim.api.keyset.create_user_command.command_args)
---@field opts vim.api.keyset.user_command?

---@type UserCommand[]
local cmds = {
	{
		name = "Date",
		command = function()
			local date = os.date('%Y-%m-%d')
			vim.api.nvim_put({ date }, 'c', true, true)
		end,
	},
	{
		name = "Scratch",
		command = function()
			vim.cmd 'bel 10new'
			local buf = vim.api.nvim_get_current_buf()
			for name, value in pairs {
				filetype = 'scratch',
				buftype = 'nofile',
				bufhidden = 'wipe',
				swapfile = false,
				modifiable = true,
			} do
				vim.api.nvim_set_option_value(name, value, { buf = buf })
			end
		end,
		opts = { desc = 'Open a scratch buffer', nargs = 0 }
	},
}


for _, cmd in ipairs(cmds) do
	vim.api.nvim_create_user_command(cmd.name, cmd.command, cmd.opts or {})
end
