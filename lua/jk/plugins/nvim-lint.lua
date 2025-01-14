local M = {
	linters_by_ft = {
		python = { "ruff", "mypy" },
		go = { "golangcilint" }
	}
}

function M.lint()
	local lint = require('lint')
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
