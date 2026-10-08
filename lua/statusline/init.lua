local utils = require "statusline.utils"
local lr_sep = utils.simple_module("%=%#StatusLine#")
local hl = require "statusline.hl"

hl.set_hl_groups()

local M = {}

function M.status()
	return utils.renderAll({
		-- left
		utils.bubble(require('statusline.components.mode')),
		require('statusline.components.branch'),
		require('statusline.components.pr'),
		require('statusline.components.diagnostics'),
		require('statusline.components.llm_usage'),


		-- div
		lr_sep,

		-- right
		utils.simple_module(vim.ui.progress_status()),
		require('statusline.components.languages'),
		utils.simple_module(vim.bo.filetype),
		utils.bubble(require('statusline.components.lsp')),
	})
end

function M.tab()
	return utils.renderAll({
		-- left
		require('statusline.components.buffers'),

		-- div
		lr_sep,

		-- right
		require('statusline.components.tabs'),
	})
end

return M
