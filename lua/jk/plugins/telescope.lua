local M = {}

function M.setup()
	local telescope = require('telescope')
	telescope.setup({})
	telescope.load_extension('projects')
end

return M
