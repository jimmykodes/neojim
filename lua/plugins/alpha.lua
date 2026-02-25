local icons = require("icons")

local function withIcon(str, icon)
	return icon .. "  " .. str
end

---@class RUFile
---@field icon string
---@field path string

---@param fn string absolute path to file
---@param cwd string absolute path to current working dir
---@return string?
local function truncateWD(fn, cwd)
	if vim.startswith(fn, cwd .. "/") and vim.fn.filereadable(fn) == 1 then
		return fn:sub(#cwd + 2)
	end
end

---@param cwd string
---@param num_files integer
---@return RUFile[]
local function oldfile(cwd, num_files)
	---@type RUFile[]
	local files = {}
	for _, _fn in ipairs(vim.v.oldfiles) do
		if #files >= num_files then
			break
		end
		local fn = truncateWD(_fn, cwd)
		if fn ~= nil and not vim.list_contains(files, fn) then
			files[#files + 1] = { icon = icons.misc.Watch, path = fn }
		end
	end
	return files
end

---@return RUFile[]
local function gitFiles(cwd)
	local topLevelResp = vim.system({ "git", "rev-parse", "--show-toplevel" }):wait()
	if topLevelResp.code ~= 0 then
		-- not a git dir
		return {}
	end
	local topLevelDir = vim.trim(topLevelResp.stdout)

	---@param cmd string[]
	---@param icon string
	---@param process function?
	---@return RUFile[]
	local function getFiles(cmd, icon, process)
		---@type RUFile[]
		local files = {}
		local resp = vim.system(cmd):wait()
		if resp.code == 0 then
			for _, fpath in ipairs(vim.split(vim.trim(resp.stdout), "\n")) do
				local func = function(s) return s end
				if process ~= nil then func = process end
				local fname = truncateWD(topLevelDir .. "/" .. func(fpath), cwd)
				if fname ~= nil then
					files[#files + 1] = { icon = icon, path = fname }
				end
			end
		end
		return files
	end

	return vim.iter({
		getFiles({ "git", "diff", "--name-only", "@{upstream}..." }, icons.git.Diff),
		getFiles({ "git", "diff", "--name-only" }, icons.git.FileUnstaged),
		getFiles({ "git", "diff", "--name-only", "--staged" }, icons.git.FileStaged),
		getFiles({ "git", "status", "--porcelain" }, icons.git.FileUntracked, function(s) return s:sub(4) end)
	}):flatten(1):totable()
end

---@param files RUFile[]
---@param file RUFile
---@return boolean
local function containsPath(files, file)
	for _, f in ipairs(files) do
		if f.path == file.path then
			return true
		end
	end
	return false
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
			button("f", withIcon("Find File", icons.ui.FindFile), require("fzf").files),
			button("r", withIcon("Recent files", icons.ui.History), require("fzf").oldfiles),
			button("t", withIcon("Find Text", icons.ui.FindText), require("fzf").find_text),
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

			local cwd = vim.fn.getcwd()

			local files = gitFiles(cwd)

			for _, file in ipairs(oldfile(cwd, num_files * 2)) do
				if #files < num_files and not containsPath(files, file) then
					files[#files + 1] = file
				end
			end

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
