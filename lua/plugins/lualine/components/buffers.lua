local icons = require("icons")

local M = require("lualine.components.buffers"):extend()

local excluded_bufs = {
	'quickfix',
	'nofile',
}

function M:init(options)
	options.component_name = 'buffers'
	options.max_length = vim.o.columns
	options.symbols = {
		modified = icons.ui.FileUnstaged,
		alternate_file = '',
		directory = icons.ui.FolderOpen,
	}
	options.fmt = function(name, buf)
		-- create iterator from current buffers
		local bufs = vim.iter(vim.api.nvim_list_bufs())
		-- filter to just listed buffers that are not this current buffer
		bufs = bufs:filter(function(n) return vim.fn.buflisted(n) ~= 0 and n ~= buf.bufnr end)
		-- map and get just the file name from each buffer path
		bufs = bufs:map(function(n) return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(n), ":t") end)
		-- if there is no buffer with the same name, return then name directly
		if bufs:find(name) == nil then
			return name
		end

		-- we found a buffer with the same name, so lets show one dir up
		-- this won't be much use if the enclosing folder names also match, but the amount of work that
		-- will take to resolve seems excessive
		-- :. -> make path relative to cwd
		-- :h -> show just the head
		-- :t -> show just the tail
		-- these mods are applied left to right, so taking the head then the tail isolates
		-- just the enclosing folder
		local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf.bufnr), [[:.:h:t]])
		if dir == "." then
			-- if the dir resolves to cwd just return file name, don't return ./<filename>
			return name
		else
			return dir .. "/" .. name
		end
	end

	M.super.init(self, options)
end

local function render_l2r(buffers, max_length)
	local data = {}
	local total_len = 0
	for i, buf in ipairs(buffers) do
		local r = buf:render()
		if total_len + buf.len > max_length then
			local last = buffers[i - 1]
			last.last = true
			last.ellipse = true
			data[#data] = last:render()
			return table.concat(data)
		else
			data[#data + 1] = r
			total_len = total_len + buf.len
		end
	end

	return table.concat(data)
end

local function render_from_idx(buffers, idx, max_length)
	local data = {}

	local total_len = 0
	local i = 0
	local buf = buffers[idx]
	if buf then
		data[#data + 1] = buf:render()
		total_len = buf.len
	end

	local buf_before, buf_after

	while true do
		i = i + 1

		buf_before = buffers[idx - i]
		buf_after = buffers[idx + i]
		local buf_before_render, buf_after_render

		if not buf_before and not buf_after then
			break
		end

		if buf_before then
			buf_before_render = buf_before:render()
			total_len = total_len + buf_before.len
			if total_len > max_length then
				break
			end
			table.insert(data, 1, buf_before_render)
		end

		if buf_after then
			buf_after_render = buf_after:render()
			total_len = total_len + buf_after.len

			if total_len > max_length then
				break
			end
			data[#data + 1] = buf_after_render
		end
	end

	-- if we've crossed the max boundary, add (...) before/after
	-- I think there is a bit of a bug here, I think we need to be replacing
	-- the last index with ... instead of adding
	if total_len > max_length then
		if buf_before ~= nil then
			buf_before.ellipse = true
			buf_before.first = true
			table.insert(data, 1, buf_before:render())
		end
		if buf_after ~= nil then
			buf_after.ellipse = true
			buf_after.last = true
			data[#data + 1] = buf_after:render()
		end
	end

	return table.concat(data)
end

function M:update_status()
	local buffers = self:buffers()

	---@type integer?
	local current = -2

	-- mark the first, last, current, before current, after current buffers for rendering
	if buffers[1] then
		buffers[1].first = true
	end
	if buffers[#buffers] then
		buffers[#buffers].last = true
	end
	for i, buffer in ipairs(buffers) do
		if buffer:is_current() then
			buffer.current = true
			current = i
			vim.g.lualine_last_current = current
			if buffers[current - 1] then
				buffers[current - 1].beforecurrent = true
			end
			if buffers[current + 1] then
				buffers[current + 1].aftercurrent = true
			end
		end
	end

	local max_length = self.options.max_length
	if type(max_length) == 'function' then
		max_length = max_length(self)
	end
	if max_length == 0 then
		max_length = math.floor(2 * vim.o.columns / 3)
	end

	if current == -2 then
		current = tonumber(vim.g.lualine_last_current)
		if current == nil then
			-- no current buffer just render buffers left to right
			return render_l2r(buffers, max_length)
		end
	end

	-- draw buffers left and right until out of space
	return render_from_idx(buffers, current, max_length)
end

function M:buffers()
	local buffers = {}
	M.bufpos2nr = {}
	for b = 1, vim.fn.bufnr('$') do
		if vim.fn.buflisted(b) ~= 0 and not vim.list_contains(excluded_bufs, vim.api.nvim_get_option_value('buftype', { buf = b })) then
			buffers[#buffers + 1] = self:new_buffer(b, #buffers + 1)
			M.bufpos2nr[#buffers] = b
		end
	end

	return buffers
end

return M
