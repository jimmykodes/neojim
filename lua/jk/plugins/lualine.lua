local icons = require("jk.icons")

local M = {}

local ignore_bufs = {
	"lspinfo",
	"toggleterm",
	"NvimTree",
	"TelescopePrompt",
	"qf",
	"lazy",
	"mason",
	"checkhealth",
	"oil",
}
local function hide_on_ignored_ft()
	local buf_ft = vim.bo.filetype
	for _, i in ipairs(ignore_bufs) do
		if i == buf_ft then
			return false
		end
	end
	return true
end

M.conditions = {
	treesitter = hide_on_ignored_ft,
	lsp = hide_on_ignored_ft,
	breadcrumbs = function()
		local status_ok, navic = pcall(require, "nvim-navic")
		return status_ok and navic.is_available()
	end
}


M.components = {
	mode = {
		"mode",
		fmt = function(name, _)
			if name == "INSERT" then
				return icons.ui.Pencil
			elseif name == "NORMAL" then
				return icons.ui.Project
			elseif name == "COMMAND" then
				return icons.ui.Code
			else
				return icons.ui.Text
			end
		end
	},
	buffers = {
		'buffers',
		max_length = vim.o.columns,
		symbols = {
			modified = icons.git.FileUnstaged,
			alternate_file = '',
			directory = icons.ui.FolderOpen,
		},
		fmt = function(name, buf)
			-- create iterator from current buffers
			local bufs = vim.iter(vim.api.nvim_list_bufs())
			-- filter to just buffers that are not this current buffer
			bufs = bufs:filter(function(n) return n ~= buf.bufnr end)
			-- map and get just the file name from each buffer path
			bufs = bufs:map(function(n) return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(n), ":t") end)

			-- if there is no buffer with the same name, return then name directly
			if bufs:find(name) == nil then
				return name
			end

			-- we found a buffer with the same name, so lets show one dir up
			-- this won't be much use if the enclosing folder names also match, but the amount of work that
			-- will take to resolve seems excessive
			-- :. -> make path releative to cwd
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
	},
	lsp = {
		function()
			local buf_clients = vim.lsp.get_clients { bufnr = 0 }
			if #buf_clients == 0 then
				return "LSP Inactive"
			end

			local buf_client_names = {}

			-- add client
			for _, client in pairs(buf_clients) do
				if client.name ~= "null-ls" then
					table.insert(buf_client_names, client.name)
				end
			end

			local buf_ft = vim.bo.filetype
			local srcs = require("jk.lsps.null_ls").list_registered_sources(buf_ft)
			for _, v in pairs(srcs) do
				vim.list_extend(buf_client_names, v)
			end

			local unique_client_names = vim.fn.uniq(buf_client_names)
			if unique_client_names ~= 0 then
				return table.concat(unique_client_names, " ")
			else
				return ""
			end
		end,
		cond = M.conditions.lsp,
		color = { gui = "bold" },
	},
	treesitter = {
		-- green if treesitter installed for buffer type, otherwise red.
		-- useful for determining when I'll need to run `:TSInstall` since
		-- I'm not doing anything automagic on buffer entry
		function()
			return icons.ui.Tree
		end,
		color = function()
			local buf = vim.api.nvim_get_current_buf()
			local ts = vim.treesitter.highlighter.active[buf]
			if ts and not vim.tbl_isempty(ts) then
				return "TSInstalled"
			end
			return "TSMissing"
		end,
		cond = M.conditions.treesitter,
	},
	breadcrumbs = {
		function()
			local status_ok, navic = pcall(require, "nvim-navic")
			return status_ok and navic.get_location() or ""
		end,
		cond = M.conditions.breadcrumbs,
	}
}


M.opts = {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = icons.ui.DividerLeft, right = icons.ui.DividerRight },
		section_separators = { left = icons.ui.BoldDividerLeft, right = icons.ui.BoldDividerRight },
		disabled_filetypes = {
			"alpha",
			"statusline",
			"winbar"
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = { M.components.mode },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { M.components.breadcrumbs },
		lualine_x = { M.components.lsp, M.components.treesitter },
		lualine_y = { 'filetype' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {
		lualine_a = { M.components.buffers },
	},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}

function M.setup()
	require("lualine").setup(M.opts)
end

return M
