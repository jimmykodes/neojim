local M = {
	filetypes = {
		extension = {
			jk = "joker",
			td = "todo",
			yaml = function(path, _)
				local s = vim.split(path, "/")
				s = s[#s]
				local match = string.match(s, "^docker%-compose[%a.]*%.ya?ml$") or string.match(s, "^compose[%a.]*%.ya?ml$")
				if match ~= nil then
					return "yaml.docker-compose"
				end
				return "yaml"
			end
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
			filetype = "gotmpl",
			used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" }
		}
	}
}

function M.setup()
	M.initFT()
	M.initParsers()

	local configs = require("nvim-treesitter.configs")

	configs.setup({
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
		sync_install = false,
		highlight = { enable = true },
		indent = { enable = true },
	})
end

function M.initFT()
	vim.filetype.add(M.filetypes)
end

function M.initParsers()
	local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
	for parser, conf in pairs(M.parsers) do
		parser_config[parser] = conf
	end
end

return M
