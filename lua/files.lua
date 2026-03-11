local icons = require("icons")

local M = {}

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
---
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


---@param cwd string
---@return fun(): RUFile?
local function gitFilesIterator(cwd)
	return coroutine.wrap(function()
		local topLevelResp = vim.system({ "git", "rev-parse", "--show-toplevel" }):wait()
		if topLevelResp.code ~= 0 then
			return -- not a git dir
		end
		local topLevelDir = vim.trim(topLevelResp.stdout)

		local function yieldFiles(cmd, icon, process)
			local resp = cmd:wait()
			if resp.code == 0 then
				for _, fpath in ipairs(vim.split(vim.trim(resp.stdout), "\n")) do
					local func = process or function(s) return s end
					local fname = truncateWD(topLevelDir .. "/" .. func(fpath), cwd)
					if fname ~= nil then
						coroutine.yield({ icon = icon, path = fname })
					end
				end
			end
		end

		local modified = vim.system({ "git", "status", "--porcelain" })
		local unstaged = vim.system({ "git", "diff", "--name-only" })
		local staged = vim.system({ "git", "diff", "--name-only", "--staged" })
		local upstream = vim.system({ "git", "diff", "--name-only", "@{upstream}..." })

		yieldFiles(upstream, icons.git.Diff)
		yieldFiles(unstaged, icons.git.FileUnstaged)
		yieldFiles(staged, icons.git.FileStaged)
		yieldFiles(modified, icons.git.FileUntracked, function(s) return s:sub(4) end)
	end)
end

---@param cwd string
---@return fun(): RUFile?
local function oldfileIterator(cwd)
	return coroutine.wrap(function()
		for _, _fn in ipairs(vim.v.oldfiles) do
			local fn = truncateWD(_fn, cwd)
			if fn ~= nil then
				coroutine.yield({ icon = icons.misc.Watch, path = fn })
			end
		end
	end)
end

---@param iterators fun(): RUFile?[]
---@param num_files integer
---@return fun(): RUFile?
local function uniqueFilesIterator(iterators, num_files)
	return coroutine.wrap(function()
		local seen = {}
		local count = 0

		for _, iterator in ipairs(iterators) do
			for file in iterator do
				if not seen[file.path] then
					seen[file.path] = true
					count = count + 1
					coroutine.yield(file)

					if count >= num_files then
						return
					end
				end
			end
		end
	end)
end

---@param num_files integer
---@return RUFile[]
function M.uniqueFiles(num_files)
	local cwd = vim.fn.getcwd()

	local iterator = uniqueFilesIterator({
		gitFilesIterator(cwd),
		oldfileIterator(cwd)
	}, num_files)

	local files = {}
	for file in iterator do
		files[#files + 1] = file
	end

	return files
end

return M
