return {
	name = "vtsls",
	cmd = { "vtsls", "--stdio" },
	filetypes = {
		'javascript',
		'javascriptreact',
		'javascript.jsx',
		'typescript',
		'typescriptreact',
		'typescript.tsx',
		"vue",
	},
	rootmarkers = { "tsconfig.json", "package.json" },
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vim.fn.stdpath("data") ..
								'/mason/packages/vue-language-server/node_modules/@vue/language-server',
						languages = { 'vue' },
						configNamespace = 'typescript',
					},
				}
			}
		}
	}
}
