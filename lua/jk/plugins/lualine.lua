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
		show_filename_only = true,     -- Shows shortened relative path when set to false.
		hide_filename_extension = false, -- Hide filename extension when set to true.
		show_modified_status = true,   -- Shows indicator when the buffer is modified.

		mode = 0,
		-- 0: Shows buffer name
		-- 1: Shows buffer index
		-- 2: Shows buffer name + buffer index
		-- 3: Shows buffer number
		-- 4: Shows buffer name + buffer number

		max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
		-- it can also be a function that returns
		-- the value of `max_length` dynamically.
		filetype_names = {
			TelescopePrompt = 'Telescope',
			dashboard = 'Dashboard',
			packer = 'Packer',
			fzf = 'FZF',
			alpha = 'Alpha'
		}, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

		-- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
		use_mode_colors = false,

		symbols = {
			modified = ' ●', -- Text to show when the buffer is modified
			alternate_file = '', -- Text to show to identify the alternate file
			directory = '', -- Text to show when the buffer is a directory
		},
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
