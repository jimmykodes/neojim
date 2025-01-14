local M = {
	cmds = {
		{
			-- hide these filetypes from buffer tabs
			events = { "FileType" },
			opts = {
				group = "_filetype_settings",
				pattern = {
					"qf",
				},
				callback = function()
					vim.cmd [[
		          set nobuflisted
		        ]]
				end,
			}
		},
		{
			events = { "BufWritePost", "BufEnter" },
			opts = {
				group = "UserLspConfig",
				pattern = "*",
				desc = "try_lint on insert leave",
				callback = function()
					require("jk.plugins.nvim-lint").lint()
				end
			},
		},
		{
			events = { "TextYankPost" },
			opts = {
				group = "_general_settings",
				pattern = "*",
				desc = "Highlight text on yank",
				callback = function()
					vim.highlight.on_yank { higroup = "Search", timeout = 100 }
				end,
			},
		},
		{
			events = { "LspAttach" },
			opts = {
				group = "UserLspConfig",
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if client ~= nil then
						-- turn off tokens in favor of treesitter
						client.server_capabilities.semanticTokensProvider = nil
					end
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
				end,
			}
		}

	}
}


function M.define_autocmds(definitions)
	for _, entry in ipairs(definitions) do
		local event = entry.events
		local opts = entry.opts

		if type(opts.group) == "string" and opts.group ~= "" then
			local ok, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
			if not ok then
				vim.api.nvim_create_augroup(opts.group, {})
			end
		end

		vim.api.nvim_create_autocmd(event, opts)
	end
end

function M.setup()
	M.define_autocmds(M.cmds)
end

return M
