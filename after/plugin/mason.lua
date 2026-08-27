require('mason').setup()
local ensure_installed = {
	"autopep8",
	"bash-language-server",
	{ "dlv",                       "delve" },
	{ "docker-compose-langserver", "docker-compose-language-service", },
	{ "docker-langserver",         "dockerfile-language-server" },
	"gofumpt",
	"goimports",
	"gopls",
	{ "graphql-lsp",                 "graphql-language-service-cli" },
	{ "helm_ls",                     "helm-ls" },
	{ "vscode-html-language-server", "html-lsp" },
	"isort",
	{ "vscode-json-language-server", "json-lsp" },
	"lua-language-server",
	"mypy",
	"prettier",
	"pyright",
	"ruff",
	"shellcheck",
	"shfmt",
	"sql-formatter",
	"terraform-ls",
	{ "tree-sitter",                 "tree-sitter-cli", },
	"ts_query_ls",
	"vim-language-server",
	"vtsls",
	"vue-language-server",
	"yaml-language-server",
}


---@param pkg string|string[]
---@return boolean
local function should_install(pkg)
	local t = type(pkg)
	if t == "string" then
		return vim.fn.executable(pkg) == 0
	elseif t == "table" then
		return vim.fn.executable(pkg[1]) == 0
	else
		return false
	end
end

local function pkg_name(pkg)
	local t = type(pkg)
	if t == "string" then
		return pkg
	elseif t == "table" then
		return pkg[2]
	end
end

local to_install = {}
for _, pkg in ipairs(ensure_installed) do
	if should_install(pkg) then
		table.insert(to_install, pkg_name(pkg))
	end
end

if #to_install > 0 then
	require('mason.api.command').MasonInstall(to_install)
end
