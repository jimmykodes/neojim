local show = false
local version = ""
vim.system({ "go", "mod", "edit", "-json" }, function(out)
	if out.code ~= 0 then
		return
	end
	show = true
	version = vim.json.decode(out.stdout).Go

	vim.schedule(function() vim.cmd("redrawstatus") end)
end)
return {
	hl = function()
		local _, hl = require("nvim-web-devicons").get_icon_by_filetype("go")
		return hl
	end,
	show = function() return show end,
	render = function()
		local icon, _ = require("nvim-web-devicons").get_icon_by_filetype("go")
		return icon .. " " .. version
	end,
}
