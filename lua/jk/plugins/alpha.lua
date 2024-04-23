local dashboard = require("alpha.themes.dashboard")
local icons = require("jk.icons")

local function withIcon(str, icon)
	return icon .. "  " .. str
end

local M = {
	header = {
		type = "text",
		val = {
			[[  __   _ _  ____]],
			[[ / /  | | |/ /\ \]],
			[[/ /_  | | ' /  \ \]],
			[[\ \ |_| | . \  / /]],
			[[ \_\___/|_|\_\/_/]],
		},
		opts = {
			position = "center",
			hl = "DashboardHeader",
		},
	},
	buttons = {
		type = "group",
		val = {
			dashboard.button("n", withIcon("New File", icons.ui.NewFile), "<CMD>ene!<CR>"),
			dashboard.button("f", withIcon("Find File", icons.ui.FindFile), "<CMD>Telescope find_files<CR>"),
			dashboard.button("r", withIcon("Recent files", icons.ui.History), "<CMD>Telescope oldfiles<CR>"),
			dashboard.button("t", withIcon("Find Text", icons.ui.FindText), "<CMD>Telescope live_grep<CR>"),
			dashboard.button("q", withIcon("Quit", icons.ui.Close), "<CMD>quit<CR>"),
		},
		opts = {
			spacing = 1,
			hl = "DashboardCenter"
		},
	},
	footer = {
		type = "text",
		val = "",
		opts = {
			position = "center",
			hl = "DashboardFooter"
		},
	},
}

function M.setup()
	local alpha = require("alpha")
	alpha.setup({
		layout = {
			{ type = "padding", val = 2 },
			M.header,
			{ type = "padding", val = 2 },
			M.buttons,
			M.footer,
		},
		opts = {
			margin = 5,
		},
	})
end

return M
