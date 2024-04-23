local M = {
	opts = {
    open_mapping = [[<C-\>]],
    hide_numbers = true,    -- hide the number column in toggleterm buffers
    shade_terminals = false,
    shading_factor = 2,     -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    direction = "float",
    close_on_exit = true,   -- close the terminal window when the process exits
    float_opts = {
      border = "curved",
    },
  }
}

function M.setup()
	require("toggleterm").setup(M.opts)
end

M.k9s = function()
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new {
    cmd = "k9s",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "none",
      width = 100000,
      height = 100000,
    },
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
    on_close = function(_) end,
    count = 99,
  }
  term:toggle()
end

M.lazygit = function()
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new {
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "none",
      width = 100000,
      height = 100000,
    },
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
    on_close = function(_) end,
    count = 99,
  }
  term:toggle()
end

M.lazydocker = function()
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new {
    cmd = "lazydocker",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "none",
      width = 100000,
      height = 100000,
    },
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
    on_close = function(_) end,
    count = 99,
  }
  term:toggle()
end

return M
