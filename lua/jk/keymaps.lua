local M = {}

---@class Keymap
---@field [string] string|function|Keymap

---@alias KeymapOpts vim.keymap.set.Opts

M.config = {
	opts = {
		silent = true,
		noremap = true,
	},
	mappings = {
		-- MARK: Insert
		i = {
			-- Navigate snippets
			["<C-m>"] = "<CMD>lua require('luasnip').jump(1)<CR>",
			["<C-,>"] = "<CMD>lua require('luasnip').jump(-1)<CR>",
			["jj"] = "<ESC>"
		},
		t = {
			['<ESC><ESC>'] = [[<C-\><C-N>]],
		},

		-- MARK: Visual Line
		x = {
			["<a-j>"] = ":m '>+1<CR>gv-gv",
			["<a-k>"] = ":m '<-2<CR>gv-gv",
		},

		-- MARK: Visual Block
		s = {
			-- Navigate snippets
			["<C-m>"] = "<CMD>lua require('luasnip').jump(1)<CR>",
			["<C-,>"] = "<CMD>lua require('luasnip').jump(-1)<CR>",
		},

		-- MARK: Visual
		v = {
			["<"] = "<gv",
			[">"] = ">gv",
			["<leader>"] = {
				["/"] = "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", -- Comment toggle linewise (visual)
				a     = {
					c = ":'<,'>LLMChatWithContext<CR>",
				},
				w     = {
					["`"] = [["pc'<C-r>p`<Esc>]], --Single Quote
					["'"] = [["pc'<C-r>p'<Esc>]], --Single Quote
					['"'] = [["pc"<C-r>p"<Esc>]], --Double Quote
					['('] = [["pc(<C-r>p)<Esc>]], --Parens
					['{'] = [["pc{<C-r>p}<Esc>]], --Braces
					['['] = [["pc[<C-r>p]<Esc>]], --Brackets
				},
				t     = {
					c = ":'<,'>StrmanCamel<cr>",     -- Camel Case
					p = ":'<,'>StrmanPascal<cr>",    -- Pascal Case
					s = ":'<,'>StrmanSnake<cr>",     -- Snake Case
					k = ":'<,'>StrmanKebab<cr>",     -- Kebab Case
					S = ":'<,'>StrmanScreamingSnake<cr>", -- Screaming Snake Case
					K = ":'<,'>StrmanScreamingKebab<cr>", -- Screaming Kebab Case
				},
			}
		},

		-- MARK: Normal
		n = {
			-- Navigate windows
			["<C-h>"] = "<C-w>h",
			["<C-j>"] = "<C-w>j",
			["<C-k>"] = "<C-w>k",
			["<C-l>"] = "<C-w>l",
			["<C-c>"] = "<C-w>c",
			["+"] = "<C-w>+",
			["-"] = "<C-w>-",

			["<a-j>"] = ":m .+1<CR>==",
			["<a-k>"] = ":m .-2<CR>==",

			-- color pick
			["<C-p>"] = ":CccPick<CR>",

			-- Navigate buffers
			["<S-l>"] = ":bnext<CR>",
			["<S-h>"] = ":bprevious<CR>",
			["<S-TAB>"] = "<C-o>",
			["<C-q>"] = ":call QuickFixToggle()<CR>",

			-- MARK: GoTo
			g = {
				D = "<cmd>lua vim.lsp.buf.declaration()<cr>", -- "Go to Declarations" },
				d = "<cmd>lua vim.lsp.buf.definition()<cr>", --, "Go to Definition" },
				I = "<cmd>lua vim.lsp.buf.implementation()<cr>", --, "Go to Implementation" },
				r = "<cmd>lua vim.lsp.buf.references()<cr>", --, "Go to References" },
				s = "<cmd>lua vim.lsp.buf.signature_help()<cr>", --, "Show Signature help" },
			},
			K = "<cmd>lua vim.lsp.buf.hover()<cr>",        -- Hover

			-- MARK: Leader
			["<leader>"] = {
				["/"] = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", -- "Comment toggle current line"
				w = "<cmd>w!<CR>",                                                   -- "Save"
				W = "<cmd>noautocmd w<cr>",                                          -- "Save without formatting"
				x = "<cmd>x<CR>",                                                    -- "Save and Quit"
				q = "<cmd>confirm q<CR>",                                            -- "Quit"
				c = "<cmd>bd<CR>",                                                   -- "Close Buffer"
				f = "<cmd>Telescope find_files<cr>",                                 --"Find File"
				h = "<cmd>nohlsearch<CR>",                                           --"No Highlight"
				e = "<cmd>NvimTreeToggle<CR>",                                       -- "Explorer"
				o = "<cmd>NvimTreeFocus<CR>",                                        --"Explorer Focus"
				n = "<cmd>Navbuddy<CR>",                                             --"Navbuddy"

				-- MARK: Apps
				A = {
					k = "<cmd>lua require 'jk.plugins.toggleterm'.k9s()<cr>", -- "k9s" },
					g = "<cmd>lua require 'jk.plugins.toggleterm'.lazygit()<cr>", -- "Git" },
					-- l = "<cmd>lua require 'jk.plugins.toggleterm'.llm()<cr>", -- "Git" },
				},

				-- MARK: Buffers
				b = {
					h = "<cmd>lua require 'jk.plugins.buffers'.close_left()<cr>", -- Close all to the left
					l = "<cmd>lua require 'jk.plugins.buffers'.close_right()<cr>", -- Close all to the right
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

				-- MARK: LSP
				l = {
					a = "<cmd>lua vim.lsp.buf.code_action()<cr>",          -- Code Actions
					l = "<cmd>lua vim.lsp.codelens.run()<cr>",             -- CodeLens Action
					r = "<cmd>lua vim.lsp.buf.rename()<cr>",               -- Rename
					j = "<cmd>lua vim.diagnostic.goto_next()<cr>",         -- Next Diagnostic
					k = "<cmd>lua vim.diagnostic.goto_prev()<cr>",         -- Prev Diagnostic
					q = "<cmd>lua vim.diagnostic.setloclist()<cr>",        --Quickfix
					f = "<cmd>lua require'conform'.format()<cr>",          -- Format
					d = "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", -- Buffer Diagnostics
					D = "<cmd>Telescope diagnostics<cr>",                  -- Diagnostics
					s = "<cmd>Telescope lsp_document_symbols<cr>",         -- Document Symbols
					S = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", -- Workspace Symbols
					e = "<cmd>Telescope quickfix<cr>",                     -- Telescope Quickfix
				},

				-- MARK: Git
				g = {
					d = "<cmd>lua require 'gitsigns'.diffthis()<cr>",                         -- Diff
					j = "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", -- Next Hunk
					k = "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", -- Prev Hunk
					l = "<cmd>lua require 'gitsigns'.blame_line()<cr>",                       -- Blame
					r = "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",                       -- Reset Hunk
					R = "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",                     -- Reset Buffer
				},

				-- MARK: Search
				s = {
					b = "<cmd>Telescope buffers<cr>",      -- Find Buffer
					f = "<cmd>Telescope find_files<cr>",   -- Find File
					h = "<cmd>Telescope help_tags<cr>",    -- Find Help
					H = "<cmd>Telescope highlights<cr>",   -- Find highlight groups
					M = "<cmd>Telescope man_pages<cr>",    -- Man Pages
					r = "<cmd>Telescope oldfiles<cr>",     -- Open Recent File
					R = "<cmd>Telescope registers<cr>",    -- Registers
					t = "<cmd>Telescope live_grep<cr>",    -- Text
					T = "<cmd>TodoTelescope<cr>",          -- Todos
					m = "<cmd>TodoTelescope keywords=MARK<cr>", -- Marks
					C = "<cmd>Telescope commands<cr>",     -- Commands
					l = "<cmd>Telescope resume<cr>",       -- Resume last search
					s = "<cmd>ScratchFind<cr>",            -- Scratch
				},

				-- MARK: LLM
				a = {
					c = "<CMD>LLMChat<CR>",
					a = "<CMD>LLMAsk<CR>",
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
	M.register_mappings(M.config.mappings, M.config.opts)
end

return M
