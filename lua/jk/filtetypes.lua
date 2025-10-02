local function yaml(path, _)
	local filename = vim.fs.basename(path)
	local docker_compose_match = string.match(filename, "^docker%-compose[%a.]*%.ya?ml$") or
			string.match(filename, "^compose[%a.]*%.ya?ml$")
	if docker_compose_match ~= nil then
		return "yaml.docker-compose"
	end
	if path:find("%.github/") then
		return "yaml.github"
	end
	if vim.fs.root(path, { "Chart.yaml" }) ~= nil then
		-- TODO: this works, but i need to do some work next
		-- time i'm poking in a helm chart to get the right
		-- queries so gotmpl injections work in the yaml
		return "helm"
	end
	return "yaml"
end

local M = {
	opts = {
		extension = {
			tf = "terraform",
			jk = "joker",
			http = "http",
			td = "todo",
			tpl = "gotmpl",
			yaml = yaml,
			yml = yaml,
		},
	},
}

function M.setup()
	vim.filetype.add(M.opts)
end

return M
