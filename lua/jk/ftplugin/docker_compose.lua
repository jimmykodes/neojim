local root_files = {
	"docker-compose.yaml",
	"docker-compose.yml",
	"compose.yaml",
	"compose.yml",
	".git"
}

local M = {
	---@type FTOpts
	opts = {
		ft = "yaml.docker-compose",
		lsp_clients = {
			{
				name = "dc_ls",
				cmd = { "docker-compose-langserver", '--stdio' },
				root_dir = vim.fs.root(0, root_files),
				commands = {
					---@param command lsp.Command
					['vscode-docker.compose.up'] = function(command)
						local file = command.arguments[1]
						if type(file) ~= "string" then
							return
						end
						-- trim file:// from start of string
						file = string.sub(file, 8)
					end,
					['vscode-docker.compose.up.subset'] = function(command)
						local file = command.arguments[1]
						if type(file) ~= "string" then
							return
						end
						-- trim file:// from start of string
						file = string.sub(file, 8)
						vim.cmd(string.format("!docker compose -f %s up -d %s", file, command.arguments[3][1]))
					end,
				}
			}
		},
		keymap_opts = {
			silent = true,
			noremap = true,
			buffer = true,
		},
		keymap = {
			n = {
				["<localleader>"] = {
					u = ":!docker compose up -d<CR>",
					s = ":!docker compose stop<CR>",
					d = ":!docker compose down<CR>",
					r = function()
						local job = require("plenary.job"):new({
							command = "docker",
							args = { "compose", "ps", "--services" },
							on_exit = function(j, return_val)
								if return_val ~= 0 then
									vim.notify("Error from llm\n" .. table.concat(j:result(), "\n"), vim.log.levels.ERROR)
									return
								end
								vim.schedule(function()
									vim.ui.select(j:result(), { prompt = "Service:" }, function(selection)
										vim.cmd(string.format("!docker compose restart %s", selection))
									end)
								end)
							end,
						}):sync()
					end
				},
			},
		},
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
