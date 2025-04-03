local icons = require "jk.icons"

local M = {
	opts = {
		auto_reload_on_write = false,
		hijack_unnamed_buffer_when_opening = true,
		root_dirs = {},
		sync_root_with_cwd = true,
		respect_buf_cwd = true,
		select_prompts = false,
		view = {
			centralize_selection = true,
		},
		renderer = {
			highlight_git = true,
			highlight_opened_files = "none",
			root_folder_label = ":t",
			indent_markers = {
				enable = false,
			},
			icons = {
				web_devicons = {
					file = {
						enable = true,
						color = true,
					},
					folder = {
						enable = false,
						color = true,
					},
				},
				glyphs = {
					default = icons.ui.Text,
					symlink = icons.ui.FileSymlink,
					bookmark = icons.ui.BookMark,
					folder = {
						arrow_closed = icons.ui.TriangleShortArrowRight,
						arrow_open = icons.ui.TriangleShortArrowDown,
						default = icons.ui.Folder,
						open = icons.ui.FolderOpen,
						empty = icons.ui.EmptyFolder,
						empty_open = icons.ui.EmptyFolderOpen,
						symlink = icons.ui.FolderSymlink,
						symlink_open = icons.ui.FolderOpen,
					},
					git = {
						unstaged = icons.git.FileUnstaged,
						staged = icons.git.FileStaged,
						unmerged = icons.git.FileUnmerged,
						renamed = icons.git.FileRenamed,
						untracked = icons.git.FileUntracked,
						deleted = icons.git.FileDeleted,
						ignored = icons.git.FileIgnored,
					},
				},
			},
			special_files = { "CODEOWNERS", "Makefile", "README.md", "readme.md" },
			symlink_destination = true,
		},
		hijack_directories = {
			enable = false, -- TODO: what does this do
			auto_open = true,
		},
		update_focused_file = {
			enable = true,
			debounce_delay = 15,
			update_root = true,
			ignore_list = {},
		},
		diagnostics = {
			enable = true,
			debounce_delay = 50,
			severity = {
				min = vim.diagnostic.severity.HINT,
				max = vim.diagnostic.severity.ERROR,
			},
			icons = {
				hint = icons.diagnostics.BoldHint,
				info = icons.diagnostics.BoldInformation,
				warning = icons.diagnostics.BoldWarning,
				error = icons.diagnostics.BoldError,
			},
		},
		filters = {
			git_ignored = false,
			custom = { ".cache", ".mypy_cache", "__pycache__", ".DS_Store", "*.bak" },
		},
		git = {
			timeout = 400,
		},
		actions = {
			open_file = {
				quit_on_open = true,
				resize_window = false, -- TODO: play with this
				window_picker = {
					exclude = {
						filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame" },
						buftype = { "nofile", "terminal", "help" },
					},
				},
			},
		},
		trash = {
			cmd = "trash",
			require_confirm = true,
		},
	}
}

function M.setup()
	require("nvim-tree").setup(M.opts)
end

return M
