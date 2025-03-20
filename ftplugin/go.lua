local opts = {
	buffer = true,
	noremap = true,
	silent = true,
}

local keymap = {
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
}

local lsps = {
	"gopls"
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


require('jk.ft').setup("go", {
	lsps = lsps,
	keymap = keymap,
	keymap_opts = opts,
	once = function()
		require("gopher").setup({})
	end
})
