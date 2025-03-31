---@class AutocmdDef
---@field event string|string[]
---@field opts vim.api.keyset.create_autocmd
local M = {
	---@type AutocmdDef[]
	cmds = {
		{
			-- hide these filetypes from buffer tabs
			event = "FileType",
			opts = {
				group = "_filetype_settings",
				pattern = { "qf" },
				callback = function() vim.cmd("set nobuflisted") end,
			}
		},
		{
			event = "TextYankPost",
			opts = {
				group = "_general_settings",
				pattern = "*",
				desc = "Highlight text on yank",
				callback = function()
					vim.highlight.on_yank({ higroup = "Search", timeout = 100 })
				end,
			},
		},
		{
			event = { "BufWritePost", "BufEnter" },
			opts = {
				group = "UserLspConfig",
				pattern = "*",
				desc = "try_lint on insert leave",
				callback = function()
					require("jk.plugins.nvim-lint").lint()
				end
			},
		},
	}
}


---Create autocommands given the provided event and opts.
---If the provided group is a string and a group with that
---name does not already exist, one will be created.
---@param definitions AutocmdDef[]
function M.define_autocmds(definitions)
	for _, def in ipairs(definitions) do
		local grp = def.opts.group
		if type(grp) == "string" and grp ~= "" then
			local ok, _ = pcall(vim.api.nvim_get_autocmds, { group = grp })
			if not ok then
				vim.api.nvim_create_augroup(grp, {})
			end
		end

		vim.api.nvim_create_autocmd(def.event, def.opts)
	end
end

function M.setup()
	M.define_autocmds(M.cmds)
end

return M
