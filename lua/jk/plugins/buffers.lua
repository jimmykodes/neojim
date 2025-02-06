local M = {}

local function close_buffers(f)
	local cb = vim.api.nvim_get_current_buf()
	vim.iter(vim.api.nvim_list_bufs()):filter(
		vim.api.nvim_buf_is_loaded
	):filter(
		function(bufnr) return f(bufnr, cb) end
	):each(function(bufnr)
		local ok, err = pcall(vim.api.nvim_buf_delete, bufnr, {})
		if not ok then
			vim.notify("Failed to delete buffer " .. bufnr .. ": " .. err, vim.log.levels.WARN)
		end
	end)
end

function M.close_right()
	close_buffers(function(bufnr, cb) return bufnr > cb end)
end

function M.close_left()
	close_buffers(function(bufnr, cb) return bufnr < cb end)
end

return M
