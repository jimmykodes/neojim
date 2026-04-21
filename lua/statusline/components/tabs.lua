local utils = require "statusline.utils"

local function activeTab(tabnr, name)
	return utils.bubble({
		hl = function() return "StatusLineInfo" end,
		show = function() return true end,
		render = function()
			if name == "" then
				return string.format("%d", tabnr)
			else
				return string.format("%d %s", tabnr, name)
			end
		end
	})
end

local function tab(tabnr, name)
	return {
		hl = function() return "StatusLineInfoInverted" end,
		show = function() return true end,
		render = function()
			return utils.renderAll({
				utils.simple_module(string.format("%d", tabnr), "StatusLineInfoInverted"),
				utils.simple_module(name)
			})
		end
	}
end


return {
	hl = function() return "StatusLine" end,
	show = function() return true end,
	render = function()
		local tabs = {}
		local current = vim.api.nvim_get_current_tabpage()
		for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
			local ok, tabname = pcall(vim.api.nvim_tabpage_get_var, tabnr, "tabname")
			if not ok or tabname == "" then
				local bufnr = vim.fn.tabpagebuflist(tabnr)[1]
				tabname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
			end
			if tabnr == current then
				table.insert(tabs, activeTab(tabnr, tabname))
			else
				table.insert(tabs, tab(tabnr, tabname))
			end
		end
		return utils.renderAll(tabs)
	end
}
