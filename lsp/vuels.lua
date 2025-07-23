---@type vim.lsp.ClientConfig
local M = {
	name = "vuels",
	cmd = { "vue-language-server", "--stdio" },
	root_markers = { "package.json", ".git" },
	filetypes = { "vue" },
	on_init = function(client)
		client.handlers['tsserver/request'] = function(_, result, context)
			local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
			if #clients == 0 then
				vim.notify('Could not found `vtsls` lsp client, vue_lsp would not work without it.', vim.log.levels.ERROR)
				return
			end
			local ts_client = clients[1]

			local param = unpack(result)
			local id, command, payload = unpack(param)
			ts_client:exec_cmd({
				title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
				command = 'typescript.tsserverRequest',
				arguments = {
					command,
					payload,
				},
			}, { bufnr = context.bufnr }, function(_, r)
				if r ~= nil then
					local response_data = { { id, r.body } }
					client:notify('tsserver/response', response_data)
				else
					vim.notify("nil response from tsserver", vim.log.levels.ERROR)
				end
			end)
		end
	end,
}

return M
