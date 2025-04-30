--if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- Augment keymaps
        ["<Leader>a"] = { desc = "Augment AI" },
        ["<Leader>ac"] = { "<cmd>Augment chat<cr>", desc = "Open Augment Chat" },
        ["<Leader>an"] = { "<cmd>Augment chat-new<cr>", desc = "Start New Augment Chat" },
        ["<Leader>at"] = { "<cmd>Augment chat-toggle<cr>", desc = "Toggle Augment Chat Panel" },
        ["<Leader>as"] = { "<cmd>Augment status<cr>", desc = "Augment Status" },
        ["<Leader>al"] = { "<cmd>Augment log<cr>", desc = "Augment Log" },
        ["<Leader>ai"] = { "<cmd>Augment signin<cr>", desc = "Augment Sign In" },
        ["<Leader>ao"] = { "<cmd>Augment signout<cr>", desc = "Augment Sign Out" },
        ["<Leader>ah"] = { "<cmd>help augment<cr>", desc = "Augment Help" },

        -- File explorer and search
        ["<Leader>e"] = { desc = "File Explorer" },
        ["<Leader>er"] = { "<cmd>RnvimrToggle<cr>", desc = "Ranger File Manager" },

        -- Telescope file and text search
        ["<Leader>ff"] = { function() require("telescope.builtin").find_files() end, desc = "Find Files" },
        ["<Leader>fg"] = { function() require("telescope.builtin").live_grep() end, desc = "Find Text" },
        ["<Leader>fb"] = { function() require("telescope.builtin").buffers() end, desc = "Find Buffers" },
        ["<Leader>fh"] = { function() require("telescope.builtin").help_tags() end, desc = "Find Help" },
        ["<Leader>fr"] = { function() require("telescope.builtin").oldfiles() end, desc = "Find Recent Files" },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
      v = {
        -- Visual mode mapping for sending selected code to Augment
        ["<Leader>ac"] = { ":Augment chat<space>", desc = "Send Selection to Augment Chat" },
      },
    },
  },
}
