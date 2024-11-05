local lspconfig = require('lspconfig')
local mason_registry = require('mason-registry')

local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() ..
		'/node_modules/@vue/language-server'

local M = {
	servers = {
		"bashls",
		"bufls",
		"cssls",
		"docker_compose_language_service",
		"dockerls",
		"gopls",
		"golangci_lint_ls",
		"helm_ls",
		"html",
		"jsonls",
		"lua_ls",
		"pyright",
		"rust_analyzer",
		"terraformls",
		"ts_ls",
		"vimls",
		"volar",
		"yamlls",
	},
	opts = {
		bashls = {
			filetypes = { 'bash', 'sh', 'zsh' },
		},
		tsserver = {
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
		},
	}
}

function M.setup()
	for _, svr in ipairs(M.servers) do
		local opts = M.opts[svr] or {}
		local default_opts = require("jk.lsps.events").get_common_opts()
		lspconfig[svr].setup(vim.tbl_deep_extend("force", default_opts, opts))
	end

	require("jk.lsps.null_ls").setup()
	require("jk.lsps.autocmd").setup()
end

return M
