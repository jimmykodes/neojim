local M = {}

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

return M
