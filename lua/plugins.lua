local icons = require("icons")

local M = {}

function M.lazy_dir()
	return vim.fn.stdpath("data") .. "/lazy"
end

M.plugins = {
	-- MARK: LSP
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	-- MARK: Formatting
	{
		"tommcdo/vim-lion",
	},

	-- MARK: Completions
	{
		"hrsh7th/nvim-cmp",
		config = function()
			require("plugins.completion").setup()
		end,
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"cmp-nvim-lsp",
			"cmp-buffer",
			"cmp-path",
			"cmp-cmdline",
			"cmp-calc",
		},
	},
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{ "hrsh7th/cmp-calc" },

	-- MARK: Functionality
	{
		"akinsho/toggleterm.nvim",
		opts = {
			open_mapping = [[<C-\>]],
			direction = "float",
			float_opts = {
				border = "curved",
			},
		},
	},
	{
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("plugins.nvim-tree").setup()
		end
	},
	-- MARK: UI
	{
		"goolord/alpha-nvim",
		config = function()
			require("plugins.alpha").setup()
		end
	},
	{
		"jimmykodes/colorschemes.nvim",
		priority = 1000,
	},
	{
		"uga-rosa/ccc.nvim",
		opts = {
			highlighter = {
				auto_enable = true,
				lsp = true,
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			attach_to_untracked = true,
		},
	},
	{
		"nvim-tree/nvim-web-devicons",
		opts = {},
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require("plugins.lualine").setup()
		end,
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			require('illuminate').configure({
				filetypes_denylist = {
					"NvimTree",
					"alpha",
				}
			})
		end
	},
	{
		'stevearc/quicker.nvim',
		opts = {},
	},
	{
		"chentoast/marks.nvim",
		opts = {},
	},

	-- MARK: Convenience
	{
		"jimmykodes/strman.nvim",
	},
	{
		"jimmykodes/incr.nvim",
	},
	{
		"jimmykodes/expand.nvim",
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			keywords = {
				MARK = {
					icon = icons.ui.BookMark,
					color = "hint"
				},
			},
			highlight = {
				keyword = "bg",
				pattern = [[.*<(KEYWORDS)[^:]*:]],
			},
			search = {
				pattern = [[\b(KEYWORDS)(?:\(\w*\)|):]],
			},
		},
	},
	{
		-- Lazy loaded by Comment.nvim pre_hook
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			pre_hook = function(...)
				local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
				if loaded and ts_comment then
					return ts_comment.create_pre_hook()(...)
				end
			end,
		},
	},
	{
		"ggandor/lightspeed.nvim",
	},
	{
		"nvim-lua/plenary.nvim",
	},
	-- MARK: fzf
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "nvim-mini/mini.icons" },
		opts = {},
	},

	-- MARK: Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
		},
	},
	{
		-- This plugin pins lines to the top of the buffer
		-- to see the context of the current line
		-- this could be function name, markdown headings,
		-- class name, etc.
		"nvim-treesitter/nvim-treesitter-context",
		opts = { multiline_threshold = 3 },
		event = { "BufRead", "BufWinEnter", "BufNewFile" },
	},

	-- MARK: DAP
	{
		"mfussenegger/nvim-dap",
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		opts = {},
	},

	-- MARK: Go
	{
		"olexsmir/gopher.nvim",
		build = ":GoInstallDeps",
	},
	{
		"leoluz/nvim-dap-go",
		ft = "go",
		opts = {},
	},

	-- MARK: Python
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		config = function()
			require('dap-python').setup("uv")

			table.insert(require('dap').configurations.python or {}, {
				name = "Remote Airflow",
				type = 'python',
				request = "attach",
				connect = {
					host = "localhost",
					port = 5678,
				},
				pathMappings = {
					{
						localRoot = "${workspaceFolder}/venv/lib/python3.11/site-packages",
						remoteRoot = "/home/airflow/.local/lib/python3.11/site-packages"
					},
					{
						localRoot = "${workspaceFolder}/dags",
						remoteRoot = "/opt/airflow/dags/repo/dags",
					}
				},
				justMyCode = false,
			})

			table.insert(require('dap').configurations.python, {
				name = "Docker",
				type = 'python',
				request = "attach",
				connect = {
					host = "localhost",
					port = 5678,
				},
				pathMappings = {
					{
						localRoot = "${workspaceFolder}",
						remoteRoot = "/app"
					}
				},
				justMyCode = false,
			})
		end
	},

	-- MARK: Neovim Dev
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {},
	},
}



function M.setup()
	local lazypath = M.lazy_dir() .. "/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable",
			lazypath
		})
	end

	vim.opt.rtp:prepend(lazypath)

	require("lazy").setup(M.plugins, {
		rocks = { enabled = false },
		performance = {
			rtp = {
				disabled_plugins = {
					'netrwPlugin',
					'tohtml',
					'tutor',
				}
			}
		}
	})
end

return M
