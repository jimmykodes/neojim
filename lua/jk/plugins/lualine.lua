local icons = require("jk.icons")

local M = {}

local ignore_bufs = {
	"lspinfo",
	"toggleterm",
	"NvimTree",
	"qf",
}
M.conditions = {
	treesitter = function()
		local buf_ft = vim.bo.filetype
		for _, i in ipairs(ignore_bufs) do
			if i == buf_ft then
				return false
			end
		end
		return true
	end,
	lsp = function()
		local buf_ft = vim.bo.filetype
		for _, i in ipairs(ignore_bufs) do
			if i == buf_ft then
				return false
			end
		end
		return true
	end,
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
	lsp = {
		function()
			local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
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

			local language_servers = table.concat(unique_client_names, " ")

			return language_servers
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
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}



function M.setup()
	require("lualine").setup(M.opts)
end

return M
