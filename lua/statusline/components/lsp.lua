local icons = require("icons")
local utils = require("statusline.utils")

local M = {
}

local function hasActiveServer()
	local buf_clients = vim.lsp.get_clients({ bufnr = 0 })

	local buf_client_names = {}

	-- add client
	for _, client in pairs(buf_clients) do
		table.insert(buf_client_names, client.name)
	end

	return #buf_client_names > 0
end

function M.hl()
	if hasActiveServer() then
		return "StatusLineSuccess"
	else
		return "StatusLineWarning"
	end
end

function M.render()
	return icons.ui.Server
end

function M.show()
	return not utils.is_ignored_ft()
end

return M
