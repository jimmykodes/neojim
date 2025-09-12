local function qftests(pkg, test)
	local text = true
	local cmd = { "go", "test" }
	if pkg then
		text = false
		vim.list_extend(cmd, { pkg })
		if test then
			vim.list_extend(cmd, { "-run", test })
		end
	else
		vim.list_extend(cmd, { "-json", "./..." })
	end
	vim.list_extend(cmd, { "2>&1" })

	local output = vim.system(cmd, { text = text }):wait()
	-- local output = vim.fn.system('go test -json ./... 2>&1')
	local qf_list = {}

	if not text then
		return output.code
	end

	for line in output.stdout:gmatch("[^\n]+") do
		local json_ok, parsed = pcall(vim.fn.json_decode, line)
		if json_ok and parsed.Action == "fail" and parsed.Test then
			table.insert(qf_list, {
				filename = parsed.Package .. '/' or "",
				context = parsed.Test,
				text = string.format("FAIL: %s", parsed.Test)
			})
		end
	end

	if #qf_list == 0 then
		vim.notify("All tests passed", vim.log.levels.INFO)
	else
		vim.api.nvim_create_autocmd("BufReadPost", {
			pattern = "quickfix",
			callback = function()
				vim.keymap.set("n", "r", function()
						local qf_idx = vim.fn.line(".")
						local item = qf_list[qf_idx]
						local code = qftests(item.filename, item.context)
						if code == 0 then
							table.remove(qf_list, qf_idx)
							vim.fn.setqflist(qf_list, 'r')
						end
					end,
					{ buffer = true })
			end
		})

		vim.fn.setqflist(qf_list)
		vim.cmd('copen')
	end
end

local M = {
	---@type FTOpts
	opts = {
		ft = "go",
		keymap = {
			n = {
				["<localleader>"] = {
					e = ':GoIfErr<CR>',
					E = [[:GoIfErr<CR>k_vg_"exdd0Ea err := ;<ESC>"eP]],
					I = [[yiwO = (*<C-r>")(nil)<ESC>0ivar _ ]],
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
					T = qftests,
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
		end,
		formatters = {
			{ "gofumpt" },
			{ "goimports" },
		},
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
