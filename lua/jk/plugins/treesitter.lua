local M = {
	filetypes = {
		extension = {
			tf = "terraform",
			jk = "joker",
			http = "http",
			td = "todo",
			yaml = function(path, _)
				local filename = vim.fs.basename(path)
				local docker_compose_match = string.match(filename, "^docker%-compose[%a.]*%.ya?ml$") or
						string.match(filename, "^compose[%a.]*%.ya?ml$")
				if docker_compose_match ~= nil then
					return "yaml.docker-compose"
				end
				if vim.fs.root(path, { ".github/" }) then
					return "yaml.github"
				end
				if vim.fs.root(path, { "Chart.yaml" }) ~= nil then
					return "helm"
				end
				return "yaml"
			end,
			tpl = function(path, _)
				if vim.fs.root(path, { "Chart.yaml" }) ~= nil then
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
					["a="] = { query = "@assignment.outer" },
					["i="] = { query = "@assignment.inner" },
					["=l"] = { query = "@assignment.lhs" },
					["=r"] = { query = "@assignment.rhs" },

					["aa"] = { query = "@parameter.outer" },
					["ia"] = { query = "@parameter.inner" },

					["ai"] = { query = "@conditional.outer" },
					["ii"] = { query = "@conditional.inner" },

					["al"] = { query = "@loop.outer" },
					["il"] = { query = "@loop.inner" },

					["ac"] = { query = "@call.outer" },
					["ic"] = { query = "@call.inner" },

					["af"] = { query = "@function.outer" },
					["if"] = { query = "@function.inner" },

					["aC"] = { query = "@class.outer" },
					["iC"] = { query = "@class.inner" },
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
					["]c"] = { query = "@call.outer" },
					["]f"] = { query = "@function.outer" },
					["]k"] = { query = "@class.outer" },
					["]i"] = { query = "@conditional.outer" },
					["]l"] = { query = "@loop.outer" },
					["]p"] = { query = "@parameter.outer" },
				},
				goto_next_end = {
					["]C"] = { query = "@call.outer" },
					["]F"] = { query = "@function.outer" },
					["]K"] = { query = "@class.outer" },
					["]I"] = { query = "@conditional.outer" },
					["]L"] = { query = "@loop.outer" },
					["]P"] = { query = "@parameter.outer" },
				},
				goto_previous_start = {
					["[c"] = { query = "@call.outer" },
					["[f"] = { query = "@function.outer" },
					["[k"] = { query = "@class.outer" },
					["[i"] = { query = "@conditional.outer" },
					["[l"] = { query = "@loop.outer" },
					["[p"] = { query = "@parameter.outer" },
				},
				goto_previous_end = {
					["[C"] = { query = "@call.outer" },
					["[F"] = { query = "@function.outer" },
					["[K"] = { query = "@class.outer" },
					["[I"] = { query = "@conditional.outer" },
					["[L"] = { query = "@loop.outer" },
					["[P"] = { query = "@parameter.outer" },
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
