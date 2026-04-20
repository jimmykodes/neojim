local ok, _ = pcall(require, 'lualine')
if not ok then return end

local icons = require("icons")

local ignore_bufs = {
	"checkhealth",
	"DressingInput",
	"lazy",
	"lspinfo",
	"mason",
	"NvimTree",
	"oil",
	"qf",
	"toggleterm",
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

local conditions = {
	treesitter = hide_on_ignored_ft,
	lsp = function()
		if not hide_on_ignored_ft() then
			return false
		else
			return #vim.lsp.get_clients({ bufnr = 0 }) > 0
		end
	end,
	tabs = function()
		return #vim.api.nvim_list_tabpages() > 1
	end,
}

local components = {
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
	lsp = {
		function()
			local buf_clients = vim.lsp.get_clients({ bufnr = 0 })

			local buf_client_names = {}

			-- add client
			for _, client in pairs(buf_clients) do
				table.insert(buf_client_names, client.name)
			end

			if #buf_client_names == 0 then
				return ""
			end

			local unique_client_names = vim.fn.uniq(buf_client_names)
			if unique_client_names ~= 0 then
				return table.concat(unique_client_names, " ")
			else
				return ""
			end
		end,
		cond = conditions.lsp,
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
			local existing
			if ts and not vim.tbl_isempty(ts) then
				existing = vim.api.nvim_get_hl(0, { name = "Added", link = false })
			else
				existing = vim.api.nvim_get_hl(0, { name = "Removed", link = false })
			end
			return { fg = string.format("#%x", existing.fg) }
		end,
		cond = conditions.treesitter,
	},
	usage = require("plugins.lualine.components.llm_usage"),
	buffers = {
		"buffers",
		symbols = {
			alternate_file = "",
		},
	},
	tabs = {
		"tabs",
		mode = 1,
		cond = conditions.tabs,
	}
}

require("lualine").setup({
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
			statusline = 100,
			tabline = 100,
		}
	},
	sections = {
		lualine_a = { components.mode },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { components.usage },
		lualine_x = { components.treesitter },
		lualine_y = { components.lsp, 'filetype' },
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
		-- lualine_a = { require("plugins.lualine.components.buffers") },
		lualine_a = { components.buffers },
		lualine_z = { components.tabs }
	},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
})
