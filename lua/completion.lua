local ok, _ = pcall(require, "cmp")
if ok then
	return
end

_G.PathCompletion = function(findstart, base)
	if findstart == 1 then
		local col = vim.api.nvim_win_get_cursor(0)[2]
		local line = vim.api.nvim_get_current_line()
		local start = col
		while start > 0 and line:sub(start, start):match('[%w_/.]') do
			start = start - 1
		end
		return start
	else
		local path

		if vim.endswith(base, "/") then
			path = base
		else
			local parts = vim.split(base, "/")
			path = table.concat(
				vim.list_slice(parts, 0, #parts - 1), "/"
			)
		end
		local it = vim.iter(vim.fs.dir(path))
		it:map(function(name, kind)
			if kind == "directory" then
				kind = "dir"
			end
			return { word = name, menu = kind }
		end)
		return it:totable()
	end
end

local cmds = {
	{
		event = "CmdlineChanged",
		opts = {
			group = 'CmdlineAutoComplete',
			pattern = '*',
			callback = function()
				vim.fn.wildtrigger()
			end,
		}
	}
}


require('autocmds').define_autocmds(cmds)


vim.opt.completeopt = { "menu", "menuone", "popup", "fuzzy", "preview", "noselect", "noinsert", "nosort" }
vim.o.autocomplete = true
vim.o.pumborder = 'rounded'
vim.o.pummaxwidth = 60
vim.o.complete = "o,Fv:lua.PathCompletion,.,w,b,u,t"

vim.o.wildmenu = true
vim.o.wildmode = "noselect:lastused,full"
vim.o.wildoptions = "pum,fuzzy"
