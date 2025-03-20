local lspconfig = require('lspconfig')
local mason_registry = require('mason-registry')

local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() ..
		'/node_modules/@vue/language-server'

---@alias LSPEntry string|{[1]: string, opts: table}

local M = {
	servers = {
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
		},                               --typescript
		"docker_compose_language_service", --docker compose
		"dockerls",                      --docker file
		"helm_ls",                       --helm
		"html",                          --html
		"jsonls",                        --json
		"pyright",                       --python
		"rust_analyzer",                 --rust
		"terraformls",                   --terraform
		"vimls",                         --vim
		"volar",                         --vue
		"yamlls",                        --yaml
		"zls",                           --zig
	},
}

function M.setup()
	M.setup_lsps(M.servers)
end

function M.setup_codelens_refresh(client, bufnr)
	local status_ok, codelens_supported = pcall(function()
		return client.supports_method "textDocument/codeLens"
	end)
	if not status_ok or not codelens_supported then
		return
	end
	local group = "lsp_code_lens_refresh"
	local cl_events = { "BufEnter", "InsertLeave" }
	local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
		group = group,
		buffer = bufnr,
		event = cl_events,
	})

	if ok and #cl_autocmds > 0 then
		return
	end
	vim.api.nvim_create_augroup(group, { clear = false })
	vim.api.nvim_create_autocmd(cl_events, {
		group = group,
		buffer = bufnr,
		callback = function(_)
			vim.lsp.codelens.refresh({ bufnr = 0 })
		end,
	})
end

function M.setup_document_symbols(client, bufnr)
	vim.g.navic_silence = false -- can be set to true to suppress error
	local symbols_supported = client.supports_method "textDocument/documentSymbol"
	if not symbols_supported then
		return
	end
	local status_ok, navic = pcall(require, "nvim-navic")
	if status_ok then
		navic.attach(client, bufnr)
	end
	local status_ok, navbuddy = pcall(require, "nvim-navbuddy")
	if status_ok then
		navbuddy.attach(client, bufnr)
	end
end

function M.common_on_attach(client, bufnr)
	M.setup_codelens_refresh(client, bufnr)
	M.setup_document_symbols(client, bufnr)
end

function M.common_capabilities()
	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_ok then
		return cmp_nvim_lsp.default_capabilities()
	end

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}

	return capabilities
end

function M.get_common_opts()
	return {
		on_attach = M.common_on_attach,
		capabilities = M.common_capabilities(),
	}
end

---@param lsps LSPEntry[]
function M.setup_lsps(lsps)
	for _, svr in ipairs(lsps) do
		local opts = {}
		if type(svr) == "table" then
			opts = svr.opts or {}
			svr = svr[1]
		end

		local default_opts = M.get_common_opts()
		lspconfig[svr].setup(vim.tbl_deep_extend("force", default_opts, opts))
	end
end

return M
