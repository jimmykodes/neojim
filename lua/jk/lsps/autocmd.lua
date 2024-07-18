-- local wk = require("which-key")

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
				end,
			}
		}
	}
}


function M.setup()
	require("jk.autocmds").define_autocmds(M.cmds)
end

return M
