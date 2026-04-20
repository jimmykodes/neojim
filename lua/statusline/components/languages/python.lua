return {
	hl = function()
		local _, hl = require("nvim-web-devicons").get_icon_by_filetype("python")
		return hl
	end,
	show = function() return vim.env.VIRTUAL_ENV ~= nil end,
	render = function()
		local icon, _ = require("nvim-web-devicons").get_icon_by_filetype("python")
		return icon .. " " .. vim.fs.basename(vim.env.VIRTUAL_ENV)
	end,
}
