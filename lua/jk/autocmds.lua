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
