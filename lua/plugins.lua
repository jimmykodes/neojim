vim.pack.add({
	-- MARK: LSP / Formatting
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/tommcdo/vim-lion",

	-- MARK: Completions
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/hrsh7th/cmp-buffer",
	"https://github.com/hrsh7th/cmp-path",
	"https://github.com/hrsh7th/cmp-cmdline",
	"https://github.com/hrsh7th/cmp-calc",

	-- MARK: Functionality
	"https://github.com/akinsho/toggleterm.nvim",
	"https://github.com/kyazdani42/nvim-tree.lua",

	-- MARK: UI
	"https://github.com/jimmykodes/colorschemes.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/stevearc/dressing.nvim",
	"https://github.com/stevearc/quicker.nvim",
	"https://github.com/goolord/alpha-nvim",
	"https://github.com/uga-rosa/ccc.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/RRethy/vim-illuminate",
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/chentoast/marks.nvim",

	-- MARK: Convenience
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/ggandor/lightspeed.nvim",
	"https://github.com/jimmykodes/llima.nvim",
	"https://github.com/jimmykodes/strman.nvim",
	"https://github.com/jimmykodes/incr.nvim",
	"https://github.com/jimmykodes/expand.nvim",

	-- MARK: fzf
	"https://github.com/ibhagwan/fzf-lua",

	-- MARK: Treesitter
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",

	-- MARK: DAP
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/nvim-neotest/nvim-nio",

	-- MARK: Go
	"https://github.com/olexsmir/gopher.nvim",
	"https://github.com/leoluz/nvim-dap-go",

	-- MARK: Python
	"https://github.com/mfussenegger/nvim-dap-python",

	-- MARK: Neovim Dev
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
})

vim.pack.add({ "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" }, {load = function() end})	

vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
			if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
			vim.cmd('TSUpdate')
		elseif name == 'gopher.nvim' and (kind == 'install' or kind == 'update') then
			if not ev.data.active then vim.cmd.packadd('gopher.nvim') end
			vim.cmd('GoInstallDeps')
		end
	end,
})
