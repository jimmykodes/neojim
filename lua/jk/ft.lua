local M = {}

---@class FTOpts
---@field ft string
---@field lsps LSPEntry[]?
---@field lsp_clients vim.lsp.ClientConfig[]?
---@field keymap Keymap?
---@field keymap_opts KeymapOpts?
---@field once function?
---@field setup function?

---@param opts FTOpts
function M.once(opts)
	if vim.g[opts.ft .. "_setup"] then
		return
	end

	vim.g[opts.ft .. "_setup"] = 1
	if opts.once ~= nil then
		opts.once()
	end
end

---@param opts FTOpts
function M.setup(opts)
	if opts.keymap ~= nil then
		require("jk.keymaps").register_mappings(opts.keymap, opts.keymap_opts)
	end

	if opts.lsp_clients then
		for _, conf in ipairs(opts.lsp_clients) do
			vim.lsp.start(conf)
		end
	end

	if opts.setup ~= nil then
		opts.setup()
	end
	M.once(opts)
end

return M
