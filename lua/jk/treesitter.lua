local M = {
	parsers = {
		-- TODO: actually register/install these.
		-- leaving them here for posterity.
		joker = {
			install_info = {
				url = "https://github.com/jimmykodes/tree-sitter-joker",
				files = { "src/parser.c" },
				branch = "main",
			}
		},
		todo = {
			install_info = {
				url = "https://github.com/jimmykodes/tree-sitter-todo",
				files = { "src/parser.c" },
				branch = "main",
			}
		},
	},
	opts = {
		ensure_installed = {
			"bash",
			"css",
			"go",
			"gomod",
			"gotmpl",
			"gowork",
			"html",
			"javascript",
			"json",
			"lua",
			"make",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"terraform",
			"vim",
			"vimdoc",
			"vue",
			"yaml",
		},
		skip = {
			"dockerfile", -- dockerfile parser does weird things with bash injections
		},
	}
}

function M.setup()
	require("nvim-treesitter.install").install(M.opts.ensure_installed)


	vim.api.nvim_create_autocmd("FileType", {
		pattern = "*",
		callback = function(args)
			local ft = vim.bo[args.buf].filetype
			local lang = vim.treesitter.language.get_lang(ft)

			if lang == nil or vim.list_contains(M.opts.skip, lang) then
				return
			end

			if require("nvim-treesitter.parsers")[lang] and vim.treesitter.language.add(lang) then
				vim.treesitter.start()
			end
		end
	})
end

return M
