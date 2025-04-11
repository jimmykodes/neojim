local root_files = {
	"go.work",
	"go.mod",
	"main.go",
	".git",
}

local M = {
	---@type FTOpts
	opts = {
		ft = "go",
		keymap = {
			n = {
				["<localleader>"] = {
					e = ':GoIfErr<CR>',
					E = [[:GoIfErr<CR>k0wvE"exdd0Ea err := ;<ESC>"eP]],
					c = ':GoCmt<CR>',
					t = {
						a = ':GoTagAdd<CR>',
						r = ':GoTagRm<CR>',
						c = function()
							vim.ui.input({ prompt = "Tag Name" }, function(input)
								require("gopher.struct_tags").add(input)
							end)
						end,
						C = function()
							vim.ui.input({ prompt = "Tag Name" }, function(input)
								require("gopher.struct_tags").remove(input)
							end)
						end

					},
					m = {
						t = ':GoMod tidy<CR>',
						i = ':GoMod init<CR>',
						v = ':GoMod vendor<CR>',
						d = ':GoMod download<CR>',
					},
					i = {
						['.'] = ':!go install .<CR>',
						c = ':!go install ./cmd/...<CR>'
					},
					b = {
						['.'] = ':!go build  .<CR>',
						c = ':!go build ./cmd/...<CR>',
					},
					r = {
						['.'] = ':!go run .<CR>',
						m = ':!go run main.go<CR>',
						f = function()
							vim.ui.input({ prompt = "File:" }, function(file)
								vim.cmd(':!go run ' .. file)
							end)
						end
					}
				}
			}
		},
		keymap_opts = {
			buffer = true,
			noremap = true,
			silent = true,
		},
		once = function()
			require("gopher").setup({})
		end
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
