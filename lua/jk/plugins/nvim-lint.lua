local lint = require('lint')
local commitlint = lint.linters.commitlint
commitlint.args = {
	"--extends",
	"@commitlint/config-conventional",
}

local M = {
	linters_by_ft = {
		python = { "ruff", "mypy" },
		go = { "golangcilint" },
		gitcommit = { "commitlint" },
	},
}

function M.lint()
	lint.linters_by_ft = M.linters_by_ft
	lint.try_lint()
end

function M.resolve_ft(ft)
	local linters = M.linters_by_ft[ft]
	if linters ~= nil then
		return linters
	end
	return {}
end

return M
