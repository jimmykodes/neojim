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
		},
		{
			"neovim/nvim-lspconfig",
		},
		{
			"nvimtools/none-ls.nvim",
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
			"ahmedkhalf/project.nvim",
			opts = {},
		},
		{
			"akinsho/toggleterm.nvim",
			lazy = false,
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
			"sourcegraph/sg.nvim",
			opts = {},
		},
		{
			"lunarvim/bigfile.nvim",
			event = { "FileReadPre", "BufReadPre", "User FileOpened" },
			opts = {},
		},
		-- MARK: UI
		{
			"goolord/alpha-nvim",
			event = "VimEnter",
			config = function()
				require("jk.plugins.alpha").setup()
			end
		},
		-- {
		-- 	"lunarvim/colorschemes",
		-- 	priority = 1000,
		-- 	lazy = false,
		-- 	config = function()
		-- 		vim.g.colors_name = "system76"
		-- 		vim.cmd("colorscheme system76")
		-- 	end
		-- },
		{
			"jimmykodes/colorschemes",
			priority = 1000,
			lazy = false,
			config = function()
				vim.g.colors_name = "system76"
				vim.cmd("colorscheme system76")
			end
		},
		{
			'akinsho/bufferline.nvim',
			dependencies = 'nvim-tree/nvim-web-devicons',
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
			config = function()
				require("jk.plugins.bufferline").setup()
			end
		},
		{
			"lewis6991/gitsigns.nvim",
			lazy = false,
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
			cmd = "Gitsigns",
			config = function()
				require("jk.plugins.gitsigns").setup()
			end
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
		},
		{ "MunifTanjim/nui.nvim" },
		{
			"SmiteshP/nvim-navic",
			dependencies = { "MunifTanjim/nui.nvim" },
			opts = {},
		},
		{
			"SmiteshP/nvim-navbuddy",
			commands = ":Navbuddy",
			dependencies = {
				"SmiteshP/nvim-navic",
				"MunifTanjim/nui.nvim",
			},
		},
		-- MARK: Convenience
		{
			"jimmykodes/strman.nvim",
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
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
			lazy = true,
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
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {}
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

		-- MARK: Telescope
		{
			"nvim-telescope/telescope.nvim",
			branch = "0.1.x",
			cmd = "Telescope",
			opts = {},
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},

		-- MARK: Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			commit = "f197a15", -- last commit to use legacy capture names, after this, markdown breaks - need to fix colorscheme to update
			build = function()
				require("nvim-treesitter.install").update({ with_sync = true })()
			end,
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
			config = function()
				require("jk.plugins.treesitter").setup()
			end
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
		-- MARK: Go
		{
			"olexsmir/gopher.nvim",
			build = ":GoInstallDeps",
			ft = "go",
			config = function()
				require("jk.plugins.gopher").setup()
			end
		},
		{
			"leoluz/nvim-dap-go",
			opts = {},
			ft = "go"
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
