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
		hl = "DashboardButtonText",
		hl_shortcut = "DashboardButtonShortcut",
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
local function file_button(char, fn, icon, opts)
	return button(string.format("e %s", char), withIcon(fn, icon), string.format("<CMD>e %s<CR>", vim.fn.fnameescape(fn)),
		opts or {})
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
			button("f", withIcon("Find File", icons.ui.FindFile), require("jk.fzf").files),
			button("r", withIcon("Recent files", icons.ui.History), require("jk.fzf").oldfiles),
			button("t", withIcon("Find Text", icons.ui.FindText), require("jk.fzf").find_text),
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
			local num_files = 10

			local files = {}
			local ok, frecency = pcall(require, "frecency")
			if ok then
				files = vim.list_slice(frecency.top(frecency.get_namespace_name()), 1, num_files)
			end
			local frecency_len = #files

			local cwd = vim.fn.getcwd()
			for _, _fn in ipairs(vim.v.oldfiles) do
				if #files >= num_files then
					break
				end
				if vim.startswith(_fn, cwd .. "/") and vim.fn.filereadable(_fn) == 1 then
					local fn = _fn:sub(#cwd + 2)
					if not vim.list_contains(files, fn) then
						files[#files + 1] = fn
					end
				end
			end

			local max = vim.iter(ipairs(files)):fold(50, function(acc, _, v) return math.max(acc, #v + 7) end)

			local val = {}
			for i, fn in ipairs(files) do
				local opts = {
					width = max
				}
				if i % 2 == 0 then
					opts.hl = "DashboardButtonTextAlt"
					opts.hl_shortcut = "DashboardButtonShortcutAlt"
				end
				local icon = icons.misc.Lightning
				if i > frecency_len then
					icon = icons.misc.Watch
				end
				val[i] = file_button(keys:sub(i, i), fn, icon, opts)
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
			{ type = "padding", val = 1 },
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
