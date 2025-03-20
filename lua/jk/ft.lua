local M = {}

---@class FTOpts
---@field lsps LSPEntry[]?
---@field keymap Keymap?
---@field keymap_opts KeymapOpts?
---@field once function?
---@field setup function?

---@param ft string
---@param opts FTOpts
function M.once(ft, opts)
	if vim.g[ft .. "_setup"] then
		return
	end
	vim.g[ft .. "_setup"] = 1
	if opts.lsps ~= nil then
		require("jk.lsps").setup_lsps(opts.lsps)
	end

	if opts.once ~= nil then
		opts.once()
	end
end

---@param ft string
---@param opts FTOpts
function M.setup(ft, opts)
	if opts.keymap ~= nil then
		require("jk.keymaps").register_mappings(opts.keymap, opts.keymap_opts)
	end
	if opts.setup ~= nil then
		opts.setup()
	end
	M.once(ft, opts)
end

return M
