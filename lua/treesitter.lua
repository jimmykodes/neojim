local function gh(repo)
	return "https://github.com/" .. repo
end
local function treesitter(language)
	return gh(string.format("tree-sitter/tree-sitter-%s", language))
end

local function treesitterGrammars(language)
	return gh(string.format("tree-sitter-grammars/tree-sitter-%s", language))
end

---@class Grammar
---@field url string
---@field branch string?
---@field dir string?
---@field rev string?

---@type table<string, string|Grammar>
local parsers = {
	bash           = treesitter("bash"),
	css            = treesitter("css"),
	go             = treesitter("go"),
	html           = treesitter("html"),
	javascript     = treesitter("javascript"),
	json           = treesitter("json"),
	python         = treesitter("python"),
	rust           = treesitter("rust"),

	hcl            = treesitterGrammars("hcl"),
	requirements   = treesitterGrammars("requirements"),
	vue            = treesitterGrammars("vue"),
	yaml           = treesitterGrammars("yaml"),
	zig            = treesitterGrammars("zig"),

	["git-config"] = gh("the-mikedavis/tree-sitter-git-config"),
	["git-rebase"] = gh("the-mikedavis/tree-sitter-git-rebase"),
	awk            = gh("Beaglefoot/tree-sitter-awk"),
	csv            = gh("weartist/rainbow-csv-tree-sitter"),
	diff           = gh("the-mikedavis/tree-sitter-diff"),
	dockerfile     = gh("camdencheek/tree-sitter-dockerfile"),
	ghostty        = gh("bezhermoso/tree-sitter-ghostty"),
	gitattributes  = gh("mtoohey31/tree-sitter-gitattributes"),
	gitcommit      = gh("gbprod/tree-sitter-gitcommit"),
	gitignore      = gh("shunsambongi/tree-sitter-gitignore"),
	gomod          = gh("camdencheek/tree-sitter-go-mod"),
	gotmpl         = gh("ngalaiko/tree-sitter-go-template"),
	gowork         = gh("omertuc/tree-sitter-go-work"),
	graphql        = gh("bkegley/tree-sitter-graphql"),
	jinja2         = gh("varpeti/tree-sitter-jinja2"),
	jq             = gh("flurie/tree-sitter-jq"),
	make           = gh("alemuller/tree-sitter-make"),
	proto          = gh("sdoerner/tree-sitter-proto"),
	task           = gh("alexanderbrevig/tree-sitter-task"),
	toml           = gh("ikatyang/tree-sitter-toml"),

	joker          = gh("jimmykodes/tree-sitter-joker"),
	todo           = gh("jimmykodes/tree-sitter-todo"),

	nginx          = "https://gitlab.com/joncoole/tree-sitter-nginx",
	typescript     = { url = treesitter("typescript"), dir = "typescript" },
}

-- to fix:
-- sql = { url = "https://github.com/DerekStride/tree-sitter-sql", branch = "gh-pages" },
-- hcl - has no queries
-- ghostty - seems to have no highlights
-- make - has highlights, but very incomplete
-- graphql - no highlights

local opts = {
	remap = {
		zsh = "bash",
		sh = "bash",
		terraform = "hcl",
	},
}

local datapath = vim.fn.stdpath("data")

local parserpath = datapath .. "/site/parser"
local queriespath = datapath .. "/site/queries"
local clonepath = datapath .. "/treesitter"

---compile a parser into {lang}.so
---@param name string
---@param parser string|Grammar
local function compile(name, parser)
	local grammar = clonepath .. "/" .. name
	if type(parser) == "table" and parser.dir ~= nil then
		grammar = string.format("%s/%s", grammar, parser.dir)
	end

	vim.system({
		"tree-sitter",
		"build",
		"-o",
		parserpath .. "/" .. name .. ".so",
		grammar,
	}, function(res)
		vim.schedule(function()
			if res.code ~= 0 then
				vim.notify(string.format("%s: treesitter error<%d>: %s", name, res.code, res.stderr), vim.log.levels.ERROR)
			else
				vim.notify(name .. " compiled")
			end
		end)
	end)
end

---copy query files from a cloned grammar
---@param name string
local function queries(name)
	local repopath = clonepath .. "/" .. name
	local languageQueries = repopath .. "/queries"
	if vim.uv.fs_stat(languageQueries) then
		vim.system({ "cp", "-r", repopath .. "/queries", queriespath .. "/" .. name }, function(res)
			if res.code ~= 0 then
				vim.schedule(function()
					vim.notify(string.format("%s: copy query error<%d>: %s", name, res.code, res.stderr), vim.log.levels.ERROR)
				end)
			end
		end)
	else
		vim.notify(string.format("%s: no queries found", name), vim.log.levels.WARN)
	end
end

---clone a parser's repo, compile it, and copy the queries
---@param name string
---@param parser string|Grammar
local function clone(name, parser)
	if vim.uv.fs_stat(parserpath .. "/" .. name .. ".so") then
		-- if the parser has already been compiled, exit early
		return
	end
	local url
	local branch = nil
	local rev = nil
	local repopath = clonepath .. "/" .. name
	if type(parser) == "table" then
		url = parser.url
		branch = parser.branch
		rev = parser.rev
	elseif type(parser) == "string" then
		url = parser
	end
	vim.notify(string.format("%s: cloning ts grammar", name))
	local cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"--depth=1",
		url,
	}
	if branch ~= nil then
		table.insert(cmd, "--branch=" .. parser.branch)
	end
	table.insert(cmd, repopath)

	vim.system(cmd, function(res)
		vim.schedule(function()
			if res.code == 0 or res.code == 128 then
				-- 0 = success
				-- 128 = repo already exists
				if rev ~= nil then
					local switchRes = vim.system({ "cd", repopath, "&&", "git", "switch", rev }):wait()
					if switchRes.code ~= 0 then
						vim.notify(
							string.format("%s: switch error<%d>: %s", name, switchRes.code, switchRes.stderr),
							vim.log.levels.ERROR
						)
						return
					end
				end
				queries(name)
				compile(name, parser)
			else
				vim.notify(string.format("%s: clone error<%d>: %s", name, res.code, res.stderr), vim.log.levels.ERROR)
			end
		end)
	end)
end

for name, parser in pairs(parsers) do
	clone(name, parser)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		local lang = vim.treesitter.language.get_lang(ft)
		lang = opts.remap[lang] or lang

		if lang == nil then
			return
		end

		if vim.treesitter.language.add(lang) then
			vim.treesitter.start(args.buf, lang)
		end
	end
})
