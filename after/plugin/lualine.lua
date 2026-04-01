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
	lsp = hide_on_ignored_ft,
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
			local buf_clients = vim.lsp.get_clients { bufnr = 0 }

			local buf_client_names = {}

			-- add client
			for _, client in pairs(buf_clients) do
				table.insert(buf_client_names, client.name)
			end

			if #buf_client_names == 0 then
				buf_client_names = { "Inactive" }
			end

			local unique_client_names = vim.fn.uniq(buf_client_names)
			if unique_client_names ~= 0 then
				return "LSP: " .. table.concat(unique_client_names, " ")
			else
				return ""
			end
		end,
		cond = conditions.lsp,
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
		lualine_x = { components.lsp, components.treesitter },
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
		-- lualine_a = { require("plugins.lualine.components.buffers") },
		lualine_a = { components.buffers },
		lualine_z = { components.tabs }
	},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
})
