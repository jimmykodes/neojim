local M = {}

function M.setup()
	require("gopher").setup()
	require("which-key").register({
		G = {
			name = "Go",
			i = { "<cmd>GoInstallDeps<Cr>", "Install Go Dependencies" },
			t = { "<cmd>GoMod tidy<cr>", "Tidy" },
			a = { "<cmd>GoTestAdd<Cr>", "Add Test" },
			A = { "<cmd>GoTestsAll<Cr>", "Add All Tests" },
			E = { "<cmd>GoTestsExp<Cr>", "Add Exported Tests" },
			g = { "<cmd>GoGenerate<Cr>", "Go Generate" },
			f = { "<cmd>GoGenerate %<Cr>", "Go Generate File" },
			c = { "<cmd>GoCmt<Cr>", "Generate Comment" },
			e = { "<cmd>GoIfErr<Cr>", "If err" },
			T = { "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test" },
		},
	}, { prefix = "<leader>" })
end

return M
