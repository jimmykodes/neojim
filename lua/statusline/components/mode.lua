local icons = require("icons")

local mode_settings = {
	["n"] = { name = "NORMAL", hl = "Normal" },
	["no"] = { name = "OP-PENDING", hl = "Pending" },
	["nov"] = { name = "OP-PENDING", hl = "Pending" },
	["noV"] = { name = "OP-PENDING", hl = "Pending" },
	["no\22"] = { name = "OP-PENDING", hl = "Pending" },
	["niI"] = { name = "NORMAL", hl = "Normal" },
	["niR"] = { name = "NORMAL", hl = "Normal" },
	["niV"] = { name = "NORMAL", hl = "Normal" },
	["nt"] = { name = "NORMAL", hl = "Normal" },
	["ntT"] = { name = "NORMAL", hl = "Normal" },
	["v"] = { name = "VISUAL", hl = "Visual" },
	["vs"] = { name = "VISUAL", hl = "Visual" },
	["V"] = { name = "V-LINE", hl = "Visual" },
	["Vs"] = { name = "V-LINE", hl = "Visual" },
	["\22"] = { name = "V-BLOCK", hl = "Visual" },
	["\22s"] = { name = "V-BLOCK", hl = "Visual" },
	["s"] = { name = "SELECT", hl = "Insert" },
	["S"] = { name = "S-LINE", hl = "Normal" },
	["\19"] = { name = "S-BLOCK", hl = "Normal" },
	["i"] = { name = "INSERT", hl = "Insert" },
	["ic"] = { name = "INSERT", hl = "Insert" },
	["ix"] = { name = "INSERT", hl = "Insert" },
	["R"] = { name = "REPLACE", hl = "Replace" },
	["Rc"] = { name = "REPLACE", hl = "Replace" },
	["Rx"] = { name = "REPLACE", hl = "Replace" },
	["Rv"] = { name = "V-REPLACE", hl = "Replace" },
	["Rvc"] = { name = "V-REPLACE", hl = "Replace" },
	["Rvx"] = { name = "V-REPLACE", hl = "Replace" },
	["c"] = { name = "COMMAND", hl = "Command" },
	["cv"] = { name = "EX", hl = "Command" },
	["ce"] = { name = "EX", hl = "Command" },
	["r"] = { name = "REPLACE", hl = "Normal" },
	["rm"] = { name = "MORE", hl = "Normal" },
	["r?"] = { name = "CONFIRM", hl = "Normal" },
	["!"] = { name = "SHELL", hl = "Normal" },
	["t"] = { name = "TERMINAL", hl = "Command" },
}

local function icon(name)
	if name == "INSERT" then
		return icons.ui.Pencil
	elseif name == "NORMAL" then
		return icons.ui.Project
	elseif name == "COMMAND" then
		return icons.ui.Code
	else
		return icons.ui.Text
	end
end


return {
	show = function() return true end,
	hl = function()
		local mode = mode_settings[vim.fn.mode()] or {}
		return "StatusLineMode" .. mode.hl
	end,
	render = function()
		local mode = mode_settings[vim.fn.mode()] or {}
		return icon(mode.name)
	end
}
