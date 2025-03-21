local M = {
	filetypes = {
		extension = {
			tf = "terraform",
			jk = "joker",
			http = "http",
			td = "todo",
			yaml = function(path, _)
				local filename = vim.fs.basename(path)
				local match = string.match(filename, "^docker%-compose[%a.]*%.ya?ml$") or
						string.match(filename, "^compose[%a.]*%.ya?ml$")
				if match ~= nil then
					return "yaml.docker-compose"
				end
				if vim.fs.root(path, { "Chart.yaml" }) ~= "" then
					return "helm"
				end
				return "yaml"
			end,
			tpl = function(path, _)
				local s = vim.split(path, "/")
				local chartIdx = vim.fn.index(s, "chart")
				if chartIdx >= 0 and s[chartIdx + 2] == "templates" then
					return "helm"
				end
				return "gotmpl"
			end,
		},
	},
	parsers = {
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
		gotmpl = {
			install_info = {
				url = "https://github.com/ngalaiko/tree-sitter-go-template",
				files = { "src/parser.c" }
			},
			used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "helm" },
		},
	},
	opts = {
		ensure_installed = {
			"bash",
			"css",
			"dockerfile",
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
			"yaml",
		},
		modules = {},
		ignore_install = {},
		auto_install = false,
		sync_install = false,
		highlight = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = ",,", -- set to `false` to disable one of the mappings
				node_incremental = ",,",
				scope_incremental = ",<",
				node_decremental = ",.",
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
					["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
					["=l"] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
					["=r"] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

					["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
					["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

					["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
					["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

					["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
					["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

					["ac"] = { query = "@call.outer", desc = "Select outer part of a function call" },
					["ic"] = { query = "@call.inner", desc = "Select inner part of a function call" },

					["af"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
					["if"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

					["aC"] = { query = "@class.outer", desc = "Select outer part of a class" },
					["iC"] = { query = "@class.inner", desc = "Select inner part of a class" },
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
					["<leader>nm"] = "@function.outer", -- swap function with next
				},
				swap_previous = {
					["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
					["<leader>pm"] = "@function.outer", -- swap function with previous
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]c"] = { query = "@call.outer", desc = "Next function call start" },
					["]f"] = { query = "@function.outer", desc = "Next method/function def start" },
					["]k"] = { query = "@class.outer", desc = "Next class start" },
					["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
					["]l"] = { query = "@loop.outer", desc = "Next loop start" },

					-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
					-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
					["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
					["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
				},
				goto_next_end = {
					["]C"] = { query = "@call.outer", desc = "Next function call end" },
					["]F"] = { query = "@function.outer", desc = "Next method/function def end" },
					["]K"] = { query = "@class.outer", desc = "Next class end" },
					["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
					["]L"] = { query = "@loop.outer", desc = "Next loop end" },
				},
				goto_previous_start = {
					["[c"] = { query = "@call.outer", desc = "Prev function call start" },
					["[f"] = { query = "@function.outer", desc = "Prev method/function def start" },
					["[k"] = { query = "@class.outer", desc = "Prev class start" },
					["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
					["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
				},
				goto_previous_end = {
					["[C"] = { query = "@call.outer", desc = "Prev function call end" },
					["[F"] = { query = "@function.outer", desc = "Prev method/function def end" },
					["[K"] = { query = "@class.outer", desc = "Prev class end" },
					["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
					["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
				},
			},
		},
	}
}

function M.setup()
	M.initFT()
	M.initParsers()

	local configs = require("nvim-treesitter.configs")

	configs.setup(M.opts)
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	vim.opt.foldlevelstart = 99
end

function M.initFT()
	vim.filetype.add(M.filetypes)
end

function M.initParsers()
	local parsers = require("nvim-treesitter.parsers")
	local ft_to_lang = parsers.ft_to_lang
	local parser_config = parsers.get_parser_configs()
	for parser, conf in pairs(M.parsers) do
		parser_config[parser] = vim.tbl_extend('force', parser_config[parser] or {}, conf)
	end
	parsers.ft_to_lang = function(ft)
		if ft == 'zsh' then
			return 'bash'
		end
		return ft_to_lang(ft)
	end
end

return M
