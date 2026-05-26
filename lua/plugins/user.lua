-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

  -- == Disabled Plugins ==

  { "nvimtools/none-ls.nvim", enabled = false },
  { "jay-babu/mason-null-ls.nvim", enabled = false },
  { "augmentcode/augment.vim", enabled = false },
  { "andweeb/presence.nvim", enabled = false },
  { "mfussenegger/nvim-dap", enabled = false },
  { "rcarriga/nvim-dap-ui", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },
  { "rcarriga/cmp-dap", enabled = false },
  { "stevearc/resession.nvim", enabled = false },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- Zellij Navigation — Ctrl+hjkl seamlessly moves between nvim windows and Zellij panes
  -- NOTE: C-a is the Zellij prefix (like tmux). Zellij intercepts C-a before nvim sees it.
  --       Use Ctrl+x to decrement, or remap increment: vim.keymap.set('n', '<leader>i', '<C-a>')
  {
    "swaits/zellij-nav.nvim",
    lazy = true,
    event = "VeryLazy",
    keys = {
      { "<c-h>", "<cmd>ZellijNavigateLeftTab<cr>", { silent = true, desc = "󰌽 navigate left" } },
      { "<c-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "󰌿 navigate down" } },
      { "<c-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "󰌽 navigate up" } },
      { "<c-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "󰌿 navigate right" } },
      -- Convenience: launch Zellij room (fuzzy tab/pane switcher) from nvim
      { "<leader>zr", "<cmd>!zellij action launch-or-focus-plugin room --floating<cr>", { silent = true, desc = "󰓓 Room (tab switcher)" } },
      { "<leader>zw", "<cmd>!zellij action launch-or-focus-plugin session-manager --floating<cr>", { silent = true, desc = "󰓓 Session Manager" } },
    },
    opts = {},
  },

  -- NOTE: Aider.nvim configuration moved to lua/plugins/aider.lua for better organization
  -- See that file for extensive keybindings and configuration

  -- NOTE: CodeCompanion.nvim configuration moved to lua/plugins/codecompanion.lua
  -- See that file for OpenCode ACP integration and keybindings

  -- NOTE: File manager integrations moved to lua/plugins/file-managers.lua
  -- See that file for rnvimr (Ranger) configuration

  -- == Examples of Overriding Plugins ==

  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        " █████  ███████ ████████ ██████   ██████",
        "██   ██ ██         ██    ██   ██ ██    ██",
        "███████ ███████    ██    ██████  ██    ██",
        "██   ██      ██    ██    ██   ██ ██    ██",
        "██   ██ ███████    ██    ██   ██  ██████",
        " ",
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
  },

  -- You can disable default plugins as follows:
  -- { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },

  {
    "stevearc/aerial.nvim",
    branch = "master",
    version = false,
    opts = function(_, opts)
      opts.ignore = opts.ignore or {}
      opts.ignore.filetypes = opts.ignore.filetypes or {}
      for _, filetype in ipairs({ "markdown", "markdown.mdx", "Avante" }) do
        if not vim.tbl_contains(opts.ignore.filetypes, filetype) then
          table.insert(opts.ignore.filetypes, filetype)
        end
      end
      return opts
    end,
  },

  -- ============ MARKDOWN PREVIEW ALTERNATIVES ============
  -- Option 1: peek.nvim - Modern Deno-based previewer (recommended)
  -- Note: Requires Deno to be installed (brew install deno)
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    ft = { "markdown", "html" },
    config = function()
      require("peek").setup {
        auto_load = true, -- automatically open preview for markdown files
        close_on_bdelete = true, -- close preview when buffer is deleted
        syntax = true, -- enable syntax highlighting
        theme = "dark", -- 'dark' or 'light'
        update_on_change = true,
        app = 'open -a "Floorp"', -- Use Floorp browser for preview
        filetype = { "markdown", "html" }, -- list of filetypes to preview
        -- Throttle time for update (in ms)
        throttle_at = 200000, -- throttle if file is larger than this (in bytes)
        throttle_time = "auto", -- minimum time between updates
      }
      -- Create user commands
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
    keys = {
      { "<leader>mp", "<cmd>PeekOpen<cr>", desc = "Peek Open (Preview)" },
      { "<leader>mc", "<cmd>PeekClose<cr>", desc = "Peek Close" },
    },
    enabled = true, -- Enabled - Deno is now installed
  },

}
