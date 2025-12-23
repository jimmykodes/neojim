local M = {}

---@class Keymap
---@field [string] string|function|Keymap

---@alias KeymapOpts vim.keymap.set.Opts

M.config = {
	opts     = {
		silent  = true,
		noremap = true,
	},
	mappings = {
		-- MARK: Insert
		i = {
			-- Navigate snippets
			["<C-l>"] = function()
				if vim.snippet.active({ direction = 1 }) then
					vim.snippet.jump(1)
				end
			end,
			["<C-h>"] = function()
				if vim.snippet.active({ direction = -1 }) then
					vim.snippet.jump(-1)
				end
			end,
			["<C-d>"] = "<esc><cmd>Date<CR>i",
		},
		t = {
			['<ESC><ESC>'] = [[<C-\><C-N>]],
		},

		-- MARK: Visual Line
		x = {
			-- Move groups of lines
			["<a-j>"] = ":m '>+1<CR>gv-gv",
			["<a-k>"] = ":m '<-2<CR>gv-gv",
		},

		-- MARK: Visual Block
		s = {},

		-- MARK: Visual
		v = {
			["<"]        = "<gv",
			[">"]        = ">gv",
			["<leader>"] = {
				["/"] = "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", -- Comment toggle linewise (visual)
				g     = {
					r = ":'<,'>Gitsigns reset_hunk<cr>",
					s = ":'<,'>Gitsigns stage_hunk<cr>",
				},
				w     = {
					["`"] = [["pc'<C-r>p`<Esc>]], --Single Quote
					["'"] = [["pc'<C-r>p'<Esc>]], --Single Quote
					['"'] = [["pc"<C-r>p"<Esc>]], --Double Quote
					['('] = [["pc(<C-r>p)<Esc>]], --Parens
					['{'] = [["pc{<C-r>p}<Esc>]], --Braces
					['['] = [["pc[<C-r>p]<Esc>]], --Brackets
				},
			}
		},

		-- MARK: Normal
		n = {
			-- Navigate windows
			["<C-h>"]    = "<C-w>h",
			["<C-j>"]    = "<C-w>j",
			["<C-k>"]    = "<C-w>k",
			["<C-l>"]    = "<C-w>l",
			["<C-c>"]    = "<C-w>c",

			["<a-j>"]    = ":m .+1<CR>==",
			["<a-k>"]    = ":m .-2<CR>==",

			-- color pick
			["<C-p>"]    = ":CccPick<CR>",

			-- Navigate buffers
			["<S-l>"]    = ":bnext<CR>",
			["<S-h>"]    = ":bprevious<CR>",

			["]"]        = {
				h = "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", -- Next Hunk
			},
			["["]        = {
				h = "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", -- Prev Hunk
			},

			g            = {
				-- MARK: LSP
				r = {
					-- n rename (vim builtin)
					-- a code action (vim builtin)
					-- r references (vim builtin)
					-- i implementation (vim builtin)
					-- t type_definition (vim builtin)
					d = "<cmd>lua vim.lsp.buf.definition()<cr>", -- Go to Definition
					l = "<cmd>lua vim.lsp.codelens.run()<cr>", -- CodeLens Action
					q = "<cmd>lua vim.diagnostic.setloclist()<cr>", -- Quickfix
				}
			},

			-- MARK: Leader
			["<leader>"] = {
				["/"] = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", -- "Comment toggle current line"
				w = "<cmd>w!<CR>",                                                   -- "Save"
				W = "<cmd>noautocmd w<cr>",                                          -- "Save without formatting"
				x = "<cmd>x<CR>",                                                    -- "Save and Quit"
				q = "<cmd>confirm q<CR>",                                            -- "Quit"
				c = "<cmd>bd<CR>",                                                   -- "Close Buffer"
				f = require("fzf").files,                                            --"Find File"
				h = "<cmd>nohlsearch<CR>",                                           --"No Highlight"
				e = "<cmd>NvimTreeToggle<CR>",                                       -- "Explorer"
				o = "<cmd>NvimTreeFocus<CR>",                                        --"Explorer Focus"

				-- MARK: Buffers
				b = {
					h = "<cmd>lua require 'plugins.buffers'.close_left()<cr>", -- Close all to the left
					l = "<cmd>lua require 'plugins.buffers'.close_right()<cr>", -- Close all to the right
				},

				-- MARK: DAP
				d = {
					t = "<cmd>lua require'dap'.toggle_breakpoint()<cr>", -- Toggle Breakpoint
					b = "<cmd>lua require'dap'.step_back()<cr>",         -- Step Back
					c = "<cmd>lua require'dap'.continue()<cr>",          -- Continue
					C = "<cmd>lua require'dap'.run_to_cursor()<cr>",     -- Run To Cursor
					d = "<cmd>lua require'dap'.disconnect()<cr>",        -- Disconnect
					g = "<cmd>lua require'dap'.session()<cr>",           -- Get Session
					i = "<cmd>lua require'dap'.step_into()<cr>",         -- Step Into
					o = "<cmd>lua require'dap'.step_over()<cr>",         -- Step Over
					u = "<cmd>lua require'dap'.step_out()<cr>",          -- Step Out
					p = "<cmd>lua require'dap'.pause()<cr>",             -- Pause
					r = "<cmd>lua require'dap'.repl.toggle()<cr>",       -- Toggle Repl
					s = "<cmd>lua require'dap'.continue()<cr>",          -- Start
					q = "<cmd>lua require'dap'.close()<cr>",             -- Quit
					U = "<cmd>lua require'dapui'.toggle({reset = true})<cr>", -- Toggle UI
				},

				-- MARK: Git
				g = {
					d = "<cmd>lua require 'gitsigns'.diffthis()<cr>",                         -- Diff
					j = "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", -- Next Hunk
					k = "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", -- Prev Hunk
					l = "<cmd>lua require 'gitsigns'.blame_line()<cr>",                       -- Blame
					r = "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",                       -- Reset Hunk
					R = "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",                     -- Reset Buffer
					s = "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",
					S = "<cmd>lua require 'gitsigns'.stage_buffer()<cr>",
					q = "<cmd>lua require 'gitsigns'.setqflist()<cr>",
				},

				-- MARK: Search
				s = {
					d = require("fzf").diag_doc,        -- Buffer Diagnostics
					D = require("fzf").diag_work,       -- Diagnostics
					s = require("fzf").lsp_document_symbols, -- Document Symbols
					b = require("fzf").buffers,         -- Find Buffer
					f = require("fzf").files,           -- Find File
					t = require("fzf").find_text,       -- Text
					r = require("fzf").resume,          -- Resume last search
				},

				-- MARK: Transforms
				T = {
					["'"] = [["pdi"h2xi'<C-r>p'<Esc>]], -- Double -> Single Quote
					['"'] = [["pdi'h2xi"<C-r>p"<Esc>]], -- Single -> Double Quote
					["("] = {
						["{"] = [["pdi(h2xi{<C-r>p}<Esc>]], -- Paren -> Brace
						["["] = [["pdi(h2xi[<C-r>p]<Esc>]], -- Paren -> Bracket
					},
					["{"] = {
						["("] = [["pdi{h2xi(<C-r>p)<Esc>]], -- Brace -> Paren
						["["] = [["pdi{h2xi[<C-r>p]<Esc>]], -- Brace -> Bracket
					},
					["["] = {
						["("] = [["pdi[h2xi(<C-r>p)<Esc>]], -- Bracket -> Paren
						["{"] = [["pdi[h2xi{<C-r>p}<Esc>]], -- Bracket -> Brace
					},
				},

				-- MARK: Terminal
				t = {
					j = ":ToggleTerm 1<cr>",
					k = ":ToggleTerm 2<cr>",
					l = ":ToggleTerm 3<cr>",
					v = {
						j = ":ToggleTerm 1 direction=vertical<cr>",
						k = ":ToggleTerm 2 direction=vertical<cr>",
						l = ":ToggleTerm 3 direction=vertical<cr>",
					},
					h = {
						j = ":ToggleTerm 1 direction=horizontal<cr>",
						k = ":ToggleTerm 2 direction=horizontal<cr>",
						l = ":ToggleTerm 3 direction=horizontal<cr>",
					},
					f = {
						j = ":ToggleTerm 1 direction=float<cr>",
						k = ":ToggleTerm 2 direction=float<cr>",
						l = ":ToggleTerm 3 direction=float<cr>",
					},
				},
			},
		},
	},
}



local function selection_to_quickfix()
	local start_pos = vim.fn.getpos(".")
	local end_pos = vim.fn.getpos("v")
	local start_line = start_pos[2]
	local end_line = end_pos[2]
	if end_line < start_line then
		start_line, end_line = end_line, start_line
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	local qf_list = {}
	for i, line in ipairs(lines) do
		---@type vim.quickfix.entry
		local entry = {
			bufnr = vim.fn.bufnr('%'),
			lnum = start_pos[2] + i - 1,
			col = i == 1 and start_pos[3] or 1,
			text = line
		}
		table.insert(qf_list, entry)
	end

	vim.fn.setqflist(qf_list)
	vim.cmd('copen')
end

---register mappings for a mod
---@param mode string
---@param mappings Keymap
---@param opts KeymapOpts
---@param prefix string?
function M.register(mode, mappings, opts, prefix)
	prefix = prefix or ""
	for k, v in pairs(mappings) do
		if type(v) == "table" then
			M.register(mode, v, opts, prefix .. k)
		else
			if type(k) == "number" then
				vim.keymap.set(mode, prefix, v, opts)
			else
				vim.keymap.set(mode, prefix .. k, v, opts)
			end
		end
	end
end

---register key mappings
---@param mappings Keymap
---@param opts KeymapOpts?
function M.register_mappings(mappings, opts)
	if opts == nil then
		opts = M.config.opts
	end
	for mode, mapping in pairs(mappings) do
		M.register(mode, mapping, opts)
	end
end

function M.setup()
	vim.keymap.set('v', '<leader>l', selection_to_quickfix, { desc = 'Selection to quickfix' })
	M.register_mappings(M.config.mappings, M.config.opts)
end

return M
