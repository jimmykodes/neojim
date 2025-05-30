local icons = require("jk.icons")

local M = {
	plugins = {
		-- MARK: LSP
		{
			"williamboman/mason.nvim",
			opts = {},
			lazy = false,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			opts = {},
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = { "williamboman/mason-lspconfig.nvim" },
		},
		{
			"mfussenegger/nvim-lint",
		},
		{
			'stevearc/conform.nvim',
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
			opts = {
				formatters_by_ft = {
					go = { "gofumpt", "goimports" },
					python = { "isort", "autopep8" },
					json = { "jq" },
				},
				format_on_save = {
					timeout_ms = 5000,
					lsp_format = "fallback",
				}
			},
		},
		-- MARK: Completions
		{
			"hrsh7th/nvim-cmp",
			config = function()
				require("jk.plugins.completion").setup()
			end,
			event = { "InsertEnter", "CmdlineEnter" },
			dependencies = {
				"cmp-nvim-lsp",
				"cmp-buffer",
				"cmp-path",
				"cmp-cmdline",
				"cmp_luasnip",
				"cmp-calc",
			},
		},
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-cmdline" },
		{ "hrsh7th/cmp-calc" },
		{ "saadparwaiz1/cmp_luasnip" },
		{
			"L3MON4D3/LuaSnip",
			config = function()
				require("luasnip.loaders.from_lua").lazy_load()
				require("luasnip.loaders.from_vscode").lazy_load()
				require("luasnip.loaders.from_snipmate").lazy_load()
			end,
			event = "InsertEnter",
			dependencies = { "friendly-snippets" },
		},
		{ "rafamadriz/friendly-snippets" },
		-- MARK: Functionality
		{
			"akinsho/toggleterm.nvim",
			cmd = "ToggleTerm",
			keys = {
				"<C-\\>",
			},
			config = function()
				require("jk.plugins.toggleterm").setup()
			end
		},
		{
			"kyazdani42/nvim-tree.lua",
			event = "VimEnter",
			config = function()
				require("jk.plugins.nvim-tree").setup()
			end
		},
		{
			"tamago324/lir.nvim",
			dependencies = {
				"nvim-tree/nvim-web-devicons"
			},
			lazy = false,
			config = function()
				local actions = require('lir.actions')
				local opts = {
					ignore = {
						"*.bak",
					},
					devicons = {
						enable = true,
						highlight_dirname = true,
					},
					mappings = {
						q = actions.quit,
						['<CR>'] = actions.edit,
					}
				}
				require('lir').setup(opts)
			end
		},
		-- MARK: UI
		{
			"goolord/alpha-nvim",
			event = "VimEnter",
			config = function()
				require("jk.plugins.alpha").setup()
			end
		},
		{
			"jimmykodes/colorschemes.nvim",
			priority = 1000,
			lazy = false,
		},
		{
			"uga-rosa/ccc.nvim",
			opts = {
				highlighter = {
					auto_enable = true,
					lsp = true,
				},
			},
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
		},
		{
			"lewis6991/gitsigns.nvim",
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
			opts = {},
		},
		{
			"nvim-tree/nvim-web-devicons",
			opts = {},
		},
		{
			"stevearc/dressing.nvim",
			opts = {},
			event = "VeryLazy"
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			event = "VimEnter",
			config = function()
				require("jk.plugins.lualine").setup()
			end,
		},
		{
			"RRethy/vim-illuminate",
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
			config = function()
				require('illuminate').configure({
					filetypes_denylist = {
						"NvimTree",
						"alpha",
					}
				})
			end
		},
		{ "MunifTanjim/nui.nvim" },
		{
			"SmiteshP/nvim-navic",
			dependencies = { "MunifTanjim/nui.nvim" },
			opts = {},
		},
		{
			"SmiteshP/nvim-navbuddy",
			cmd = "Navbuddy",
			dependencies = {
				"SmiteshP/nvim-navic",
				"MunifTanjim/nui.nvim",
			},
		},
		{
			'stevearc/quicker.nvim',
			event = "FileType qf",
			---@module "quicker"
			---@type quicker.SetupOptions
			opts = {},
		},
		{
			"chentoast/marks.nvim",
			event = "VeryLazy",
			opts = {},
		},
		-- MARK: Convenience
		{
			"jimmykodes/strman.nvim",
			cmd = {
				"StrmanCamel",
				"StrmanPascal",
				"StrmanSnake",
				"StrmanKebab",
				"StrmanSeparate",
				"StrmanScreamingSnake",
				"StrmanScreamingKebab",
			}
		},
		{
			"jimmykodes/incr.nvim",
			cmd = {
				"IncrInt",
				"IncrIntBy",
			}
		},
		{
			'windwp/nvim-autopairs',
			event = "InsertEnter",
			opts = {},
		},
		{
			"folke/todo-comments.nvim",
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
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
					pattern = [[.*<(KEYWORDS)(\(\w*\)|):]],
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
			event = "BufRead"
		},
		{
			"nvim-lua/plenary.nvim",
			cmd = { "PlenaryBustedFile", "PlenaryBustedDirectory" },
		},
		{
			"code-biscuits/nvim-biscuits",
			event = "BufRead",
			opts = {
				cursor_line_only = true,
			},
		},

		-- MARK: Notes
		{
			"jimmykodes/scratch.nvim",
			opts = {
				find_prompt_icon = icons.ui.Telescope
			},
			cmd = {
				"ScratchNew",
				"ScratchOpen",
				"ScratchFind",
			}
		},
		{
			"jimmykodes/epistle.nvim",
			opts = {
				find_prompt_icon = icons.ui.Telescope,
				dir = "$CODE_DIR/devlog/"
			},
			cmd = {
				"EpistleNewFromSelection",
				"EpistleOpen",
				"EpistleToday",
				"EpistleFind",
			}
		},
		-- MARK: AI
		{
			"jimmykodes/chat.nvim",
			cmd = {
				"LLMAsk",
				"LLMNew",
				"LLMSelect",
				"LLMChat",
				"LLMChatWithContext",
			},
		},
		-- MARK: Telescope
		{
			"nvim-telescope/telescope.nvim",
			branch = "0.1.x",
			cmd = "Telescope",
			config = function()
				require('jk.plugins.telescope').setup()
			end
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},

		-- MARK: Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			build = function()
				require("nvim-treesitter.install").update({ with_sync = true })()
			end,
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
			dependencies = {
				"nvim-treesitter/nvim-treesitter-context",
				"nvim-treesitter/nvim-treesitter-textobjects",
			},
			config = function()
				require("jk.plugins.treesitter").setup()
			end
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = { multiline_threshold = 3 },
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
		},
		-- MARK: DAP
		{
			"mfussenegger/nvim-dap",
			lazy = false,
		},
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
			opts = {},
			lazy = false,
		},
		-- MARK: Language Specific

		-- Go
		{
			"olexsmir/gopher.nvim",
			build = ":GoInstallDeps",
		},
		{
			"leoluz/nvim-dap-go",
			ft = "go",
			opts = {},
		},

		-- Python
		{
			"mfussenegger/nvim-dap-python",
			ft = "python",
			config = function()
				require('dap-python').setup("/Users/jimmykeith/.venv/dap/bin/python")

				table.insert(require('dap').configurations.python or {}, {
					name = "Remote Airflow",
					type = 'python',
					request = "attach",
					connect = {
						host = "localhost",
						port = 5778,
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
		-- Neovim
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {},
		},
	}
}

function M.setup()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
		defaults = { lazy = true },
	})
end

return M
