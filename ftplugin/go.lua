vim.g.maplocalleader = ","

local opts = {
	buffer = true,
	noremap = true,
	silent = true,
}

vim.keymap.set('n', '<localleader>e', ':GoIfErr<CR>')
vim.keymap.set('n', '<localleader>ta', ':GoTagAdd<CR>')
vim.keymap.set('n', '<localleader>tr', ':GoTagRm<CR>')
vim.keymap.set('n', '<localleader>mt', ':GoMod tidy<CR>')

local function setup()
	-- 	vim.lsp.start({ name = 'llmsp', cmd = { 'llmsp' } })
	-- local id = vim.lsp.start({ name = 'copilot', cmd = { 'copilot-language-server', "--stdio" } })
	-- if id == nil then
	-- 	return
	-- end

	-- local client = vim.lsp.get_client_by_id(id)
	-- if client == nil then
	-- 	return
	-- end
	-- local success = client.request("workspace/executeCommand",
	-- { command = "github.copilot.activated", arguments = {} })
end

if not vim.g.llmsp_started then
	vim.g.llmsp_started = 1
	setup()
end
