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
		lsp_clients = {
			{
				name = "gopls",
				cmd = { 'gopls' },
				filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
				root_dir = vim.fs.root(0, root_files),
			}
		},
		keymap = {
			n = {
				["<localleader>"] = {
					e = ':GoIfErr<CR>',
					c = ':GoCmt<CR>',
					t = {
						a = ':GoTagAdd<CR>',
						r = ':GoTagRm<CR>',
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


-- require("which-key").register({
-- 	G = {
-- 		name = "Go",
-- 		i = { "<cmd>GoInstallDeps<Cr>", "Install Go Dependencies" },
-- 		t = { "<cmd>GoMod tidy<cr>", "Tidy" },
-- 		a = { "<cmd>GoTestAdd<Cr>", "Add Test" },
-- 		A = { "<cmd>GoTestsAll<Cr>", "Add All Tests" },
-- 		E = { "<cmd>GoTestsExp<Cr>", "Add Exported Tests" },
-- 		g = { "<cmd>GoGenerate<Cr>", "Go Generate" },
-- 		f = { "<cmd>GoGenerate %<Cr>", "Go Generate File" },
-- 		c = { "<cmd>GoCmt<Cr>", "Generate Comment" },
-- 		e = { "<cmd>GoIfErr<Cr>", "If err" },
-- 		T = { "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test" },
-- 	},
-- }, { prefix = "<leader>" })


---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
