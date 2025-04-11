return {
	name = "tsqueryls",
	cmd = { "ts_query_ls" },
	root_markers = { "queries" },
	filetypes = { "query" },
	init_options = {
		parser_install_directories = {
			-- If using nvim-treesitter with lazy.nvim
			vim.fs.joinpath(
				vim.fn.stdpath('data'),
				'/lazy/nvim-treesitter/parser/'
			),
		},
		parser_aliases = {
			ecma = 'javascript',
		},
		language_retrieval_patterns = {
			'languages/src/([^/]+)/[^/]+\\.scm$',
		},
	},

}
