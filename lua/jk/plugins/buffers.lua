local M = {}

function M.close_right()
	local cb = vim.api.nvim_get_current_buf()
	local buffers = vim.iter(vim.api.nvim_list_bufs())
	buffers:each(function(bufnr)
		if vim.api.nvim_buf_is_loaded(bufnr) and bufnr > cb then
			vim.api.nvim_buf_delete(bufnr, {})
		end
	end)
end

function M.close_left()
	local cb = vim.api.nvim_get_current_buf()
	local buffers = vim.iter(vim.api.nvim_list_bufs())
	buffers:each(function(bufnr)
		if vim.api.nvim_buf_is_loaded(bufnr) and bufnr < cb then
			vim.api.nvim_buf_delete(bufnr, {})
		end
	end)
end

return M
