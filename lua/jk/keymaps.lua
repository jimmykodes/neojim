local M = {}

M.config = {
	opts = { silent = true },
	mappings = {
		i = {
			-- Navigate snippets
			["<C-m>"] = "<CMD>lua require('luasnip').jump(1)<CR>",
			["<C-,>"] = "<CMD>lua require('luasnip').jump(-1)<CR>",
		},
		s = {
			-- Navigate snippets
			["<C-m>"] = "<CMD>lua require('luasnip').jump(1)<CR>",
			["<C-,>"] = "<CMD>lua require('luasnip').jump(-1)<CR>",
		},
		v = {
			["<"] = "<gv",
			[">"] = ">gv",
		},
		n = {
			-- Navigate windows
			["<C-h>"] = "<C-w>h",
			["<C-j>"] = "<C-w>j",
			["<C-k>"] = "<C-w>k",
			["<C-l>"] = "<C-w>l",
			["<C-c>"] = "<C-w>c",

			-- Navigate buffers
			["<S-l>"] = ":bnext<CR>",
			["<S-h>"] = ":bprevious<CR>",
			["<S-TAB>"] = "<C-o>",
			["<C-q>"] = ":call QuickFixToggle()<CR>",
		},
	},
	whichkey = {
		setup     = {},
		opts      = {
			mode = "n",  -- NORMAL mode
			prefix = "<leader>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		},
		vopts     = {
			mode = "v",  -- VISUAL mode
			prefix = "<leader>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		},
		mappings  = {
			[";"] = { "<cmd>Alpha<CR>", "Dashboard" },
			["w"] = { "<cmd>w!<CR>", "Save" },
			["x"] = { "<cmd>x<CR>", "Save and Quit" },
			["q"] = { "<cmd>confirm q<CR>", "Quit" },
			["/"] = { "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", "Comment toggle current line" },
			["c"] = { "<cmd>bd<CR>", "Close Buffer" },
			["f"] = { "<cmd>Telescope find_files<cr>", "Find File" },
			["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
			["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
			["o"] = { "<cmd>NvimTreeFocus<CR>", "Explorer Focus" },
			["n"] = { "<cmd>Navbuddy<CR>", "Navbuddy" },
			a = {
				name = "Apps",
				k = { "<cmd>lua require 'jk.plugins.toggleterm'.k9s()<cr>", "k9s" },
				g = { "<cmd>lua require 'jk.plugins.toggleterm'.lazygit()<cr>", "Git" },
				d = { "<cmd>lua require 'jk.plugins.toggleterm'.lazydocker()<cr>", "Docker" },
			},
			b = {
				name = "Buffers",
				j = { "<cmd>BufferLinePick<cr>", "Jump" },
				f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
				b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
				n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
				W = { "<cmd>noautocmd w<cr>", "Save without formatting" },
				e = {
					"<cmd>BufferLinePickClose<cr>",
					"Pick which buffer to close",
				},
				h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
				l = {
					"<cmd>BufferLineCloseRight<cr>",
					"Close all to the right",
				},
				D = {
					"<cmd>BufferLineSortByDirectory<cr>",
					"Sort by directory",
				},
				L = {
					"<cmd>BufferLineSortByExtension<cr>",
					"Sort by language",
				},
			},
			d = {
				name = "Debug",
				t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
				b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
				c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
				C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
				d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
				g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
				i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
				o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
				u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
				p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
				r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
				s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
				q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
				U = { "<cmd>lua require'dapui'.toggle({reset = true})<cr>", "Toggle UI" },
			},
			g = {
				name = "Git",
				d = { "<cmd>lua require 'gitsigns'.diffthis()<cr>", "Diff" },
				j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
				k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
				l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
				r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
				R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
			},
			l = {
				name = "LSP",
				a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
				d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
				w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
				j = {
					"<cmd>lua vim.diagnostic.goto_next()<cr>",
					"Next Diagnostic",
				},
				k = {
					"<cmd>lua vim.diagnostic.goto_prev()<cr>",
					"Prev Diagnostic",
				},
				l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
				q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
				r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
				s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
				S = {
					"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
					"Workspace Symbols",
				},
				e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
			},
			-- MARK: Search
			s = {
				name = "Search",
				f = { "<cmd>Telescope find_files<cr>", "Find File" },
				h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
				H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
				M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
				r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
				R = { "<cmd>Telescope registers<cr>", "Registers" },
				t = { "<cmd>Telescope live_grep<cr>", "Text" },
				T = { "<cmd>TodoTelescope<cr>", "Todos" },
				m = { "<cmd>TodoTelescope keywords=MARK<cr>", "Marks" },
				C = { "<cmd>Telescope commands<cr>", "Commands" },
				l = { "<cmd>Telescope resume<cr>", "Resume last search" },
			},
			-- MARK: Transforms
			T = {
				name = "Transform",
				["'"] = { [["pdi"h2xi'<C-r>p'<Esc>]], "Single Quote" },
				['"'] = { [["pdi'h2xi"<C-r>p"<Esc>]], "Double Quote" },
				["("] = {
					name = "Paren -> _",
					["{"] = { [["pdi(h2xi{<C-r>p}<Esc>]], "Paren -> Brace" },
					["["] = { [["pdi(h2xi[<C-r>p]<Esc>]], "Paren -> Bracket" },
				},
				["{"] = {
					name = "Brace -> _",
					["("] = { [["pdi{h2xi(<C-r>p)<Esc>]], "Brace -> Paren" },
					["["] = { [["pdi{h2xi[<C-r>p]<Esc>]], "Brace -> Bracket" },
				},
				["["] = {
					name = "Bracket -> _",
					["("] = { [["pdi[h2xi(<C-r>p)<Esc>]], "Bracket -> Paren" },
					["{"] = { [["pdi[h2xi{<C-r>p}<Esc>]], "Bracket -> Brace" },
				},
			},
			-- MARK: Terminal
			t = {
				name = "Terminal",
				j = { ":ToggleTerm 1<cr>", "Terminal 1" },
				k = { ":ToggleTerm 2<cr>", "Terminal 2" },
				l = { ":ToggleTerm 3<cr>", "Terminal 3" },
				v = {
					name = "Vertical",
					j = { ":ToggleTerm 1 direction=vertical<cr>", "Terminal 1" },
					k = { ":ToggleTerm 2 direction=vertical<cr>", "Terminal 2" },
					l = { ":ToggleTerm 3 direction=vertical<cr>", "Terminal 3" },
				},
				h = {
					name = "Horizontal",
					j = { ":ToggleTerm 1 direction=horizontal<cr>", "Terminal 1" },
					k = { ":ToggleTerm 2 direction=horizontal<cr>", "Terminal 2" },
					l = { ":ToggleTerm 3 direction=horizontal<cr>", "Terminal 3" },
				},
				f = {
					name = "Float",
					j = { ":ToggleTerm 1 direction=float<cr>", "Terminal 1" },
					k = { ":ToggleTerm 2 direction=float<cr>", "Terminal 2" },
					l = { ":ToggleTerm 3 direction=float<cr>", "Terminal 3" },
				},
			}
		},

		vmappings = {
			["/"] = { "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", "Comment toggle linewise (visual)" },
			l     = {
				name = "LSP",
				a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
			},
			w     = {
				name = "Wrap",
				["'"] = { [["pc'<C-r>p'<Esc>]], "Single Quote" },
				['"'] = { [["pc"<C-r>p"<Esc>]], "Double Quote" },
				['('] = { [["pc(<C-r>p)<Esc>]], "Parens" },
				['{'] = { [["pc{<C-r>p}<Esc>]], "Braces" },
				['['] = { [["pc[<C-r>p]<Esc>]], "Brackets" },
			},
			t     = {
				c = { ":'<,'>StrmanCamel<cr>", "Camel Case" },
				p = { ":'<,'>StrmanPascal<cr>", "Pascal Case" },
				s = { ":'<,'>StrmanSnake<cr>", "Snake Case" },
				k = { ":'<,'>StrmanKebab<cr>", "Kebab Case" },
				S = { ":'<,'>StrmanScreamingSnake<cr>", "Screaming Snake Case" },
				K = { ":'<,'>StrmanScreamingKebab<cr>", "Screaming Kebab Case" },
			},
		},
	},
}

function M.setup()
	local which_key = require("which-key")
	local wk = M.config.whichkey
	which_key.setup(wk.setup)
	which_key.register(wk.mappings, wk.opts)
	which_key.register(wk.vmappings, wk.vopts)

	for mode, mappings in pairs(M.config.mappings) do
		for k, v in pairs(mappings) do
			vim.keymap.set(mode, k, v, M.config.opts)
		end
	end
end

return M
