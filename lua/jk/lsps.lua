---@alias LSPEntry string|{[1]: string, opts: table}

local M = {
	---@type string[]
	servers = {
		"bashls",
		"dockerls",
		"gopls",
		"graphql_ls",
		"helmls",
		"journey_lsp",
		"jsonls",
		"lua_ls",
		"pyright",
		"rust_analyzer",
		"tsqueryls",
		"vimls",
		"vtsls",
		"vuels",
		"yamlls",
	},
}

function M.setup()
	vim.lsp.config("*", {
		on_attach = M.common_on_attach,
		capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), M.common_capabilities()),
		root_markers = { '.git' },
	})
	vim.lsp.enable(M.servers)
	vim.diagnostic.config({ virtual_text = true })
	vim.lsp.inlay_hint.enable(true)
end

---start the lsp directly using vim.lsp.start
---@param conf vim.lsp.ClientConfig
function M.start_lsp(conf)
	local default_conf = M.get_common_opts()
	local opts = vim.tbl_deep_extend("force", default_conf, conf)
	local client_id = vim.lsp.start(opts)
	if client_id == nil then
		return
	end
end

function M.setup_codelens_refresh(client, bufnr)
	local status_ok, codelens_supported = pcall(function()
		return client.supports_method "textDocument/codeLens"
	end)
	if not status_ok or not codelens_supported then
		return
	end

	-- refresh right away
	vim.lsp.codelens.refresh({ bufnr = bufnr })

	local group = "lsp_code_lens_refresh"
	local cl_events = { "BufEnter", "InsertLeave", "TextChanged" }
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

function M.common_on_attach(client, bufnr)
	-- turn off tokens in favor of treesitter
	client.server_capabilities.semanticTokensProvider = nil

	-- Enable completion triggered by <c-x><c-o>
	vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

	if vim.fn.maparg("grf", "n") == "" then
		-- we didn't set the keymap to format, which means we didn't set an autocommand either.
		vim.keymap.set("n", "grf", function() vim.lsp.buf.format() end, { buffer = true, desc = "lsp format" })
		require('jk.autocmds').define_autocmds({
			{
				event = "BufWritePre",
				opts = {
					buffer = bufnr,
					group = "UserFormatOnSave",
					callback = function() vim.lsp.buf.format() end,
				}
			}
		})
	end

	M.setup_codelens_refresh(client, bufnr)
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
	}
end

return M
