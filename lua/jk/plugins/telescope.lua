local actions = require('telescope.actions')
local M = {
	opts = {
		defaults = {},
		mappings = {
			i = {
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
			},
		},
		pickers = {
			find_files = {
				find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
			},
		},
	},
}

function M.setup()
	local conf = require("telescope.config")

	local vimgrep_arguments = { unpack(conf.values.vimgrep_arguments) }
	-- include hidden files when searching text
	table.insert(vimgrep_arguments, "--hidden")
	-- exclude .git from text search
	table.insert(vimgrep_arguments, "--glob")
	table.insert(vimgrep_arguments, "!**/.git/*")
	M.opts.defaults.vimgrep_arguments = vimgrep_arguments

	require('telescope').setup(M.opts)
end

return M
