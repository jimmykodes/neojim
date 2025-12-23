local M = {}

---@type Linter
function M.mypy(bufnr)
	local filename = vim.fn.bufname(bufnr)
	return {
		"mypy",
		"--output",
		"json",
		filename
	}
end

local severities = {
	error = vim.diagnostic.severity.ERROR,
	warning = vim.diagnostic.severity.WARN,
	note = vim.diagnostic.severity.INFO,
}
---@type Parser
function M.mypyParse(output, filename)
	if output == '' then
		vim.schedule(function()
			vim.notify("no output to parse")
		end)
		return {}
	end

	return vim.iter(vim.split(vim.trim(output), "\n")):map(function(line)
		local item = vim.json.decode(line)

		if item.file ~= filename then
			vim.schedule(function()
				vim.notify(item.file .. " != " .. filename)
			end)
			return nil
		end

		---@type vim.Diagnostic
		return {
			lnum = item.line > 0 and item.line - 1 or 0,
			col = item.column,
			severity = severities[item.severity] or severities.warning,
			source = "mypy",
			message = item.message,
			code = item.code,
		}
	end):totable()
end

---@type FTOpts
M.opts = {
	ft = "py",
	formatters = {
		{ "autopep8", "-" },
		{ "isort",    "-" },
	},
	lint = {
		name = "mypy",
		cmd = M.mypy,
		parser = M.mypyParse,
		expectedCode = 1,
	}
}


---@param opts FTOpts?
function M.setup(opts)
	require('jk.ft').setup(M.opts, opts)
end

return M
