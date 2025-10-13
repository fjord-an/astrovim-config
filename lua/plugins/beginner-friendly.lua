-- Beginner-friendly quality of life improvements for note-taking
return {
  -- Which-key for showing keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      show_help = true,
      show_keys = true,
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
      },
      preset = "modern",
    },
  },

  -- Better search highlighting
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
  },

  -- Auto-save for note-taking (saves every few seconds)
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = { "InsertLeave", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" },
      },
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        -- Don't auto-save certain file types
        if utils.not_in(fn.getbufvar(buf, "&filetype"), { "oil", "neo-tree" }) then
          return true
        end
        return false
      end,
      write_all_buffers = false,
      debounce_delay = 1000, -- Save after 1 second of inactivity
    },
  },

  -- Better undo history visualization
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },

  -- Distraction-free writing mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        backdrop = 0.95,
        width = 80,
        height = 1,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = true },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
      },
    },
  },

  -- Highlight and dim inactive code
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    opts = {
      dimming = {
        alpha = 0.25,
        color = { "Normal", "#ffffff" },
        term_bg = "#000000",
        inactive = false,
      },
      context = 10,
      treesitter = true,
    },
  },

  -- Better markdown support
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
    ft = { "markdown", "Avante" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
  },

  -- Smooth scrolling for better navigation
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
    },
  },
}