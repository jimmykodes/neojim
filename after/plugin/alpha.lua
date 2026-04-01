local icons = require("icons")
local fileHandlers = require("files")

local function withIcon(str, icon)
	return icon .. "  " .. str
end

local function button(shortcut, value, keybind, opts)
	-- for multi stage keycodes, "f f" becomes "ff" but is still displayed as "f f"
	local sc_ = shortcut:gsub("%s", "")

	opts = vim.tbl_extend('force', {
		position = "center",
		shortcut = shortcut,
		cursor = 3,
		width = 50,
		align_shortcut = "right",
		hl = "DashboardButtonText",
		hl_shortcut = "DashboardButtonShortcut",
	}, opts or {})

	if keybind then
		opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true, nowait = true } }
	end

	return {
		type = "button",
		val = value,
		on_press = function() end,
		opts = opts,
	}
end

---return a button
---@param char	string
---@param fn string
---@return table
local function file_button(char, fn, icon, opts)
	return button(string.format("e %s", char), withIcon(fn, icon), string.format("<CMD>e %s<CR>", vim.fn.fnameescape(fn)),
		opts or {})
end

local header = {
	type = "text",
	val = {
		[[  ___   _     _ _ __  ____]],
		[[ / / \ | |   | (_)  \/  \ \]],
		[[/ /|  \| |_  | | | |\/| |\ \]],
		[[\ \| |\  | |_| | | |  | |/ /]],
		[[ \_\_| \_|\___/|_|_|  |_/_/]],
	},
	opts = {
		position = "center",
		hl = "DashboardHeader",
	},
}

local buttons = {
	type = "group",
	val = {
		button("n", withIcon("New File", icons.ui.NewFile), "<CMD>ene!<CR>"),
		button("l", withIcon("Llima", icons.ui.Network), "<CMD>LlimaOpen<CR>"),
		button("f", withIcon("Find File", icons.ui.FindFile), require("fzf").files),
		button("t", withIcon("Find Text", icons.ui.FindText), require("fzf").find_text),
		button("q", withIcon("Quit", icons.ui.Close), "<CMD>quit<CR>"),
	},
	opts = {
		spacing = 1,
		hl = "DashboardCenter"
	},
}

local mru = {
	type = "group",
	val = function()
		local keys = "asdfghjkl;"
		local num_files = 10

		local files = fileHandlers.uniqueFiles(num_files)

		local max = vim.iter(ipairs(files)):fold(50, function(acc, _, v) return math.max(acc, #v.path + 7) end)

		local val = {}
		for i, fn in ipairs(files) do
			local opts = {
				width = max
			}
			if i % 2 == 0 then
				opts.hl = "DashboardButtonTextAlt"
				opts.hl_shortcut = "DashboardButtonShortcutAlt"
			end
			val[i] = file_button(keys:sub(i, i), fn.path, fn.icon, opts)
		end
		return {
			{ type = "text",    val = "Recently Used Files", opts = { hl = "SpecialComment", position = "center" } },
			{ type = "padding", val = 1 },
			{ type = "group",   val = val },
		}
	end,
	opts = {
		spacing = 0,
		hl = "DashboardCenter"
	},
}

local footer = {
	type = "text",
	val = "version: " .. tostring(vim.version()),
	opts = {
		position = "center",
		hl = "SpecialComment"
	},
}

require("alpha").setup({
	layout = {
		{ type = "padding", val = 2 },
		header,
		{ type = "padding", val = 2 },
		buttons,
		{ type = "padding", val = 1 },
		mru,
		{ type = "padding", val = 1 },
		footer,
	},
	opts = {
		margin = 5,
	},
})
