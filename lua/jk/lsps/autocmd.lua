local wk = require("which-key")

local M = {
	cmds = {
		{
			events = { "BufWritePre" },
			opts = {
				group = "lsp_format_on_save",
				pattern = "*",
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							local filetype = vim.bo.filetype
							local n = require("null-ls")
							local s = require("null-ls.sources")
							local method = n.methods.FORMATTING
							local available_formatters = s.get_available(filetype, method)

							if #available_formatters > 0 then
								return client.name == "null-ls"
							elseif client.supports_method "textDocument/formatting" then
								return true
							else
								return false
							end
						end
					})
				end,
			}
		},
		{
			events = { "LspAttach" },
			opts = {
				group = "UserLspConfig",
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					client.server_capabilities.semanticTokensProvider = nil
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

					local opts = { buffer = ev.buf }
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					wk.register({
						g = {
							D = { vim.lsp.buf.declaration, "Go to Declarations" },
							d = { vim.lsp.buf.definition, "Go to Definition" },
							I = { vim.lsp.buf.implementation, "Go to Implementation" },
							r = { vim.lsp.buf.references, "Go to References" },
							s = { vim.lsp.buf.signature_help, "Show Signature help" },
						}
					}, opts)
					wk.register({
						l = {
							name = "lsp",
							w = {
								name = "workspace",
								a = { vim.lsp.buf.add_workspace_folder, "Add Folder" },
								r = { vim.lsp.buf.remove_workspace_folder, "Remove Folder" },
								l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List Folders" },
							},
							a = { vim.lsp.buf.code_action, "Code Actions", mode = { 'n', 'v' } },
							d = { vim.lsp.buf.type_definition, "Type Definition" },
							r = { vim.lsp.buf.rename, "Rename" },
							f = { function() vim.lsp.buf.format { async = true } end, "Format" },
						},
					}, { prefix = "<leader>", buffer = ev.buf })
				end,
			}
		}
	}
}


function M.setup()
	require("jk.autocmds").define_autocmds(M.cmds)
end

return M
