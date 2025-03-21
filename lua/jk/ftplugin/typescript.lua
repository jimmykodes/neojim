local mason_registry = require('mason-registry')

local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() ..
		'/node_modules/@vue/language-server'

local M = {
	---@type FTOpts
	opts = {
		ft = "",
		lsps = { "volar", --vue
			{
				"ts_ls",
				opts = {
					filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
					init_options = {
						plugins = {
							{
								name = "@vue/typescript-plugin",
								location = vue_language_server_path,
								languages = { 'vue' },
							},
						},
					},
				}
			}, --typescript

		},
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
