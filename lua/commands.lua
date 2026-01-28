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
	{
		name = "GitCommitMsg",
		command = function()
			local cmd = { 'git', 'status', '-s' }
			local status = vim.system(cmd):wait()
			if status.code ~= 0 then
				vim.notify("not a git repo", vim.log.levels.ERROR)
				return
			end
			local lines = vim.fn.split(status.stdout, "\n")
			for i, line in ipairs(lines) do
				lines[i] = "# " .. line
			end

			vim.cmd 'enew'
			local buf = vim.api.nvim_get_current_buf()
			for name, value in pairs {
				filetype = 'gitcommit',
				buftype = 'nofile',
				swapfile = false,
				modifiable = true,
			} do
				vim.api.nvim_set_option_value(name, value, { buf = buf })
			end
			vim.api.nvim_buf_set_name(buf, "COMMIT_EDITMSG")
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			local commit = function()
				local buf_lines = vim.iter(vim.api.nvim_buf_get_lines(buf, 0, -1, false))
				buf_lines = buf_lines:filter(function(line) return not vim.startswith(line, "#") end):totable()

				local commit_msg = table.concat(buf_lines, '\n')

				-- Run git commit with the message
				local commit_cmd = { 'git', 'commit', '-m', commit_msg }
				local commit_resp = vim.system(commit_cmd):wait()
				if commit_resp.code == 0 then
					vim.notify("Committed", vim.log.levels.INFO)
					-- Close the buffer
					vim.cmd('q')
				else
					vim.notify("Error commiting: " .. commit_resp.stderr)
				end
			end
			vim.api.nvim_buf_create_user_command(buf, "GitWriteCommit", commit, { desc = "write commit", nargs = 0 })
			vim.api.nvim_buf_set_keymap(buf, "n", "<leader>gw", "<cmd>GitWriteCommit<cr>", { silent = true, noremap = true })
		end,
		opts = { desc = 'Write a git commit message', nargs = 0 }
	},
}

for _, cmd in ipairs(cmds) do
	vim.api.nvim_create_user_command(cmd.name, cmd.command, cmd.opts or {})
end
