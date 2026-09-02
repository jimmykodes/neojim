local M = {}

---@class Fmt
---@field event string
---@field callback function

---@class FTOpts
---@field ft string
---@field lsps LSPEntry[]?
---@field lsp_clients vim.lsp.ClientConfig[]?
---@field keymap Keymap?
---@field keymap_opts KeymapOpts?
---@field once function?
---@field setup function?
---@field autocmds AutocmdDef[]?
---@field formatters string[][]?
---@field lint Lint?

---@param cmd string[]
---@param input string
---@return string
local function run_format(cmd, input)
	local output = vim.system(cmd, { stdin = input }):wait()
	return vim.trim(output.stdout)
end

local function apply_format(new_text)
	local old_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local new_lines = vim.split(new_text, "\n", { plain = true })

	-- trim a possible trailing empty string from split (if new_text ends with \n)
	if new_lines[#new_lines] == "" then
		table.remove(new_lines)
	end

	local old_text = table.concat(old_lines, "\n")
	if old_text == table.concat(new_lines, "\n") then
		return -- nothing changed, don't touch the buffer at all
	end

	local hunks = vim.text.diff(old_text, table.concat(new_lines, "\n"), {
		result_type = "indices",
		algorithm = "histogram",
	})

	if not hunks then
		return
	end

	-- apply hunks in reverse so earlier line numbers stay valid
	for i = #hunks, 1, -1 do
		local start_a, count_a, start_b, count_b = unpack(hunks[i])

		-- vim.diff uses 1-based, "0 count" meaning pure insertion/deletion
		local replacement = {}
		for j = start_b, start_b + count_b - 1 do
			table.insert(replacement, new_lines[j])
		end

		local remove_start, remove_end
		if count_a == 0 then
			-- pure insertion after line start_a
			remove_start = start_a
			remove_end = start_a
		else
			remove_start = start_a - 1
			remove_end = start_a - 1 + count_a
		end

		vim.api.nvim_buf_set_lines(0, remove_start, remove_end, false, replacement)
	end
end

local function format(formatters)
	return function()
		local data = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
		for _, fmt in ipairs(formatters) do
			data = run_format(fmt, data)
		end
		if #data == 0 then
			return
		end
		apply_format(data)
	end
end

---@param opts FTOpts
local function once(opts)
	if vim.g[opts.ft .. "_setup"] then
		return
	end

	if opts.autocmds then
		require('autocmds').define_autocmds(opts.autocmds)
	end

	if opts.formatters ~= nil and #opts.formatters > 0 then
		require('autocmds').define_autocmds({
			{
				event = "BufWritePre",
				opts = {
					pattern = "*." .. opts.ft,
					group = "UserFormatOnSave",
					callback = format(opts.formatters),
				}
			}
		})
	end

	if opts.lint ~= nil then
		local ns_id = vim.api.nvim_create_namespace(opts.lint.name)
		require('autocmds').define_autocmds({
			{
				event = "BufWritePost",
				opts = {
					pattern = "*." .. opts.ft,
					group = "UserLint",
					callback = function(args)
						require('lint').lint(ns_id, opts.lint, args)
					end,
				},
			},
		})
	end


	if opts.lsps then
		require('lsps').setup_lsps(opts.lsps)
	end

	if opts.once ~= nil then
		opts.once()
	end

	vim.g[opts.ft .. "_setup"] = 1
end


---@param opts FTOpts
local function _setup(opts)
	if opts.keymap ~= nil then
		require("keymaps").register_mappings(opts.keymap, opts.keymap_opts)
	end

	if opts.lsp_clients then
		for _, conf in ipairs(opts.lsp_clients) do
			require("lsps").start_lsp(conf)
		end
	end

	if opts.setup ~= nil then
		opts.setup()
	end
	once(opts)

	vim.keymap.set("n", "grf", format(opts.formatters), { buffer = true, desc = "ft format" })
end

---@param opts FTOpts
---@param user_opts FTOpts?
function M.setup(opts, user_opts)
	_setup(vim.tbl_extend("force", opts, user_opts or {}))
end

return M
