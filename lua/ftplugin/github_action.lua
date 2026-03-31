local M = {
	---@type FTOpts
	opts = {
		ft = "yaml.github",
	}
}

---@param opts FTOpts?
function M.setup(opts)
	require('ft').setup(M.opts, opts)
	vim.api.nvim_create_user_command("ActionVersions", function(args)
		local line = vim.api.nvim_get_current_line()
		local repo = line:match("%s+uses:%s+(.-)@")
		if not repo then
			vim.notify("ActionVersions: could not parse repo from line", vim.log.levels.ERROR)
			return
		end
		vim.notify("fetching versions for '" .. repo .. "'")
		local output = vim.system({ "gh", "release", "list", "--json", "tagName", "--jq", ".[].tagName", "--repo", repo })
				:wait()
		if output.code ~= 0 then
			vim.notify(output.stderr, vim.log.levels.ERROR)
		else
			vim.notify(output.stdout)
		end
	end, {})
end

return M
