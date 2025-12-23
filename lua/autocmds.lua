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
				desc = "make buffers unlisted",
				pattern = { "qf", "scratch" },
				callback = function() vim.cmd("set nobuflisted") end,
			}
		},
		{
			event = "FileType",
			opts = {
				group    = "_filetype_settings",
				desc     = "close files with q",
				pattern  = {
					"qf",
					"help",
					"scratch",
				},
				callback = function(args)
					if args.match ~= 'help' or not vim.bo[args.buf].modifiable then
						vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
					end
				end
			},
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
