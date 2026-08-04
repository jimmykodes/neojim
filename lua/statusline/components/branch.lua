local icons = require "icons"
local utils = require "statusline.utils"
local show_branch = false
local show_repo = false
local branch = ""
local repo = ""

local function fetch_branch()
	vim.system({ "git", "branch", "--show-current" }, function(resp)
		if resp.code ~= 0 then
			return
		end
		show_branch = true
		branch = vim.trim(resp.stdout)
		utils.redraw()
	end)
end

local function fetch_toplevel()
	vim.system({ "git", "rev-parse", "--show-toplevel" }, function(resp)
		if resp.code ~= 0 then
			return
		end
		repo = vim.fn.fnamemodify(vim.trim(resp.stdout), ":t")
		show_repo = true
		utils.redraw()
	end)
end

local function fetch_common_dir()
	vim.system({ "git", "rev-parse", "--git-common-dir" }, function(resp)
		if resp.code ~= 0 then
			return
		end
		repo = vim.fn.fnamemodify(vim.trim(resp.stdout), ":t")
		if repo == ".git" then
			vim.schedule(fetch_toplevel)
		else
			show_repo = true
			utils.redraw()
		end
	end)
end


fetch_branch()
fetch_common_dir()

return {
	hl = function() return "StatusLineSuccessInverted" end,
	show = function()
		return show_branch and show_repo
	end,
	render = function()
		return icons.git.Branch .. " " .. repo .. ":" .. branch
	end
}
