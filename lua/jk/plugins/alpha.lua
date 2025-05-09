local icons = require("jk.icons")

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
		hl_shortcut = "Keyword",
	}, opts or {})

	if keybind then
		opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true, nowait = true } }
	end

	local function on_press()
		-- runs when <CR> is pressed while cursor is on the button
		local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
		vim.api.nvim_feedkeys(key, "t", false)
	end

	return {
		type = "button",
		val = value,
		on_press = on_press,
		opts = opts,
	}
end

---return a button
---@param char	string
---@param fn string
---@return table
local function file_button(char, fn, opts)
	return button(string.format("e %s", char), fn, "<CMD>e " .. fn .. "<CR>",
		vim.tbl_extend('force', { align_shortcut = "right" }, opts or {}))
end


local M = {
	header = {
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
	},
	buttons = {
		type = "group",
		val = {
			button("n", withIcon("New File", icons.ui.NewFile), "<CMD>ene!<CR>"),
			button("f", withIcon("Find File", icons.ui.FindFile), "<CMD>Telescope find_files<CR>"),
			button("r", withIcon("Recent files", icons.ui.History), "<CMD>Telescope oldfiles<CR>"),
			button("t", withIcon("Find Text", icons.ui.FindText), "<CMD>Telescope live_grep<CR>"),
			button("l", withIcon("Lazy", icons.ui.Package), "<CMD>Lazy<CR>"),
			button("m", withIcon("Mason", icons.ui.Server), "<CMD>Mason<CR>"),
			button("q", withIcon("Quit", icons.ui.Close), "<CMD>quit<CR>"),
		},
		opts = {
			spacing = 1,
			hl = "DashboardCenter"
		},
	},
	mru = {
		type = "group",
		val = function()
			local keys = "asdfghjkl;"
			local max = 0
			local files = {}
			local val = {}
			local cwd = vim.fn.getcwd()
			for _, _fn in ipairs(vim.v.oldfiles) do
				if vim.startswith(_fn, cwd .. "/") then
					local fn = _fn:gsub(cwd, ".")
					local fn_len = #fn
					if fn_len > max then
						max = fn_len
					end
					files[#files + 1] = fn
					if #files >= 10 then
						break
					end
				end
			end

			max = max + 5
			if max < 50 then
				max = 50
			end

			for i, fn in ipairs(files) do
				val[i] = file_button(keys:sub(i, i), fn, { width = max })
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
	},
	footer = {
		type = "text",
		val = "version: " .. tostring(vim.version()),
		opts = {
			position = "center",
			hl = "SpecialComment"
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
			{ type = "padding", val = 2 },
			M.mru,
			{ type = "padding", val = 1 },
			M.footer,
		},
		opts = {
			margin = 5,
		},
	})
end

return M
