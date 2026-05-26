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
        spell = true, -- Enable spell checking for note-taking
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = true, -- Enable word wrap for long lines in notes
        linebreak = true, -- Break lines at word boundaries
        breakindent = true, -- Preserve indentation in wrapped lines
        clipboard = "unnamed,unnamedplus", -- enable system clipboard integration

        -- Better for note-taking
        conceallevel = 2, -- Hide markdown syntax for cleaner view
        scrolloff = 8, -- Keep 8 lines visible above/below cursor
        sidescrolloff = 8, -- Keep 8 characters visible left/right of cursor
        cursorline = true, -- Highlight current line

        -- Indentation settings for better readability
        tabstop = 2,
        shiftwidth = 2,
        expandtab = true,
        smartindent = true,

        -- Search improvements
        ignorecase = true, -- Case insensitive search
        smartcase = true, -- Smart case search
        hlsearch = true, -- Highlight search results
        incsearch = true, -- Incremental search

        -- File handling
        backup = false, -- Don't create backup files
        writebackup = false, -- Don't create backup while writing
        swapfile = false, -- Disable swap files (with auto-save, these are annoying)
        undofile = true, -- Enable persistent undo
        undolevels = 10000, -- More undo levels

        -- Better completion
        completeopt = "menu,menuone,noselect",
        pumheight = 10, -- Limit popup menu height

        -- Mouse support for beginners
        mouse = "a", -- Enable mouse in all modes

        -- Better split behavior
        splitbelow = true, -- Horizontal splits go below
        splitright = true, -- Vertical splits go to the right
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

        -- [REMOTE ONLY] File explorer and search
        ["<Leader>e"] = { desc = "File Explorer" },
        ["<Leader>en"] = { "<Cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree Explorer" },
        ["<Leader>eN"] = { "<Cmd>Neotree reveal<CR>", desc = "Reveal Current File" },
        ["<Leader>eg"] = { "<Cmd>Neotree float git_status<CR>", desc = "Git Status Explorer" },
        ["<Leader>eb"] = { "<Cmd>Neotree float buffers<CR>", desc = "Buffer Explorer" },
        ["<Leader>er"] = { "<cmd>RnvimrToggle<cr>", desc = "Toggle Ranger" },
        ["<Leader>ef"] = { "<cmd>RnvimrToggle<cr>", desc = "Toggle Ranger (alternative)" },
        -- Note: <leader>ec and <leader>es are defined in user.lua with custom functions
        ["<Leader>ec"] = { desc = "Ranger (current file - search)" },
        ["<Leader>es"] = { desc = "Ranger (select current file exactly)" },

        -- [REMOTE ONLY] Telescope file and text search
        ["<Leader>ff"] = { function() require("telescope.builtin").find_files() end, desc = "Find Files" },
        ["<Leader>fg"] = { function() require("telescope.builtin").live_grep() end, desc = "Find Text" },
        ["<Leader>fb"] = { function() require("telescope.builtin").buffers() end, desc = "Find Buffers" },
        ["<Leader>fh"] = { function() require("telescope.builtin").help_tags() end, desc = "Find Help" },
        ["<Leader>fr"] = { function() require("telescope.builtin").oldfiles() end, desc = "Find Recent Files" },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- ============ BEGINNER-FRIENDLY SHORTCUTS ============
        -- Super easy save with Ctrl+S (like every other editor)
        ["<C-s>"] = { "<cmd>w<cr>", desc = "Save file" },

        -- Quick quit with Ctrl+Q
        ["<C-q>"] = { "<cmd>q<cr>", desc = "Quit" },

        -- Redo mappings
        ["<C-r>"] = { "<C-r>", desc = "Redo" },  -- Restore default redo (fixes which-key override)
        ["<D-S-z>"] = { "<C-r>", desc = "Redo (Command-Shift-Z)" },
        ["<D-y>"] = { "<C-r>", desc = "Redo (Command-Y)" },

        -- Escape alternative (jj is easier than reaching for Esc)
        -- Note: This will be in insert mode below

        -- Undo tree for visual undo history
        ["<Leader>u"] = { "<cmd>UndotreeToggle<cr>", desc = "Toggle Undo Tree" },

        -- Zen mode for distraction-free writing
        ["<Leader>z"] = { "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },

        -- Obsidian note shortcuts
        ["<Leader>o"] = { desc = "Obsidian Notes" },
        ["<Leader>on"] = { "<cmd>ObsidianNew<cr>", desc = "New Note" },
        ["<Leader>oo"] = { "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian" },
        ["<Leader>os"] = { "<cmd>ObsidianSearch<cr>", desc = "Search Notes" },
        ["<Leader>oq"] = { "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch" },
        ["<Leader>ot"] = { "<cmd>ObsidianToday<cr>", desc = "Today's Note" },
        ["<Leader>oy"] = { "<cmd>ObsidianYesterday<cr>", desc = "Yesterday's Note" },
        ["<Leader>ob"] = { "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
        ["<Leader>ol"] = { "<cmd>ObsidianLinks<cr>", desc = "Links" },
        ["<Leader>of"] = { "<cmd>ObsidianFollowLink<cr>", desc = "Follow Link" },
        ["<Leader>or"] = { "<cmd>ObsidianRename<cr>", desc = "Rename Note" },
        ["<Leader>ow"] = { "<cmd>ObsidianWorkspace<cr>", desc = "Switch Workspace" },
        ["<Leader>om"] = { "<cmd>ObsidianTomorrow<cr>", desc = "Tomorrow's Note" },

        -- Quick capture shortcuts (minimal friction)
        ["<Leader>oc"] = {
          function()
            -- Open today's note and jump to Quick Capture section
            vim.cmd("ObsidianToday")
            vim.defer_fn(function()
              vim.fn.search("## Quick Capture", "w")
              vim.cmd("normal! j$")
              vim.cmd("startinsert!")
            end, 100)
          end,
          desc = "Quick Capture"
        },
        ["<Leader>oj"] = {
          function()
            -- Open today's note and jump to Journal section
            vim.cmd("ObsidianToday")
            vim.defer_fn(function()
              vim.fn.search("## Journal", "w")
              vim.cmd("normal! jo")
              vim.cmd("startinsert")
            end, 100)
          end,
          desc = "Journal Entry"
        },
        ["<Leader>ok"] = {
          function()
            -- Open today's note and jump to Tasks section
            vim.cmd("ObsidianToday")
            vim.defer_fn(function()
              vim.fn.search("## Tasks", "w")
              vim.cmd("normal! jo- [ ] ")
              vim.cmd("startinsert!")
            end, 100)
          end,
          desc = "Add Task"
        },

        -- Markdown/HTML Preview shortcuts
        ["<Leader>m"] = { desc = " Markdown/Preview" },
        ["<Leader>mp"] = { "<cmd>PeekOpen<cr>", desc = "Peek Preview (Browser)" },
        ["<Leader>mc"] = { "<cmd>PeekClose<cr>", desc = "Peek Close" },
        ["<Leader>ml"] = { "<cmd>LiveServerStart<cr>", desc = "Start Live Server" },
        ["<Leader>ms"] = { "<cmd>LiveServerStop<cr>", desc = "Stop Live Server" },
        ["<Leader>mt"] = { "<cmd>LiveServerToggle<cr>", desc = "Toggle Live Server" },

        -- Snippets/Cheatsheets shortcuts
        ["<Leader>s"] = { desc = "📚 Snippets/Cheatsheets" },
        ["<Leader>so"] = { "<cmd>CheatsheetsOpen<cr>", desc = "Open Cheatsheets" },
        ["<Leader>sg"] = { "<cmd>CheatsheetsGrep<cr>", desc = "Search Cheatsheets" },
        ["<Leader>sn"] = { "<cmd>CheatsheetNew<cr>", desc = "New Cheatsheet" },

        -- Quick navigation (easier than remembering complex motions)
        ["<Leader>w"] = { "<cmd>w<cr>", desc = "Save (Alternative)" },
        ["<Leader>x"] = { "<cmd>x<cr>", desc = "Save and Quit" },

        -- Search and replace made easy
        ["<Leader>sr"] = { ":%s/", desc = "Search & Replace" },

        -- Toggle line numbers (sometimes you want clean view)
        ["<Leader>tn"] = { "<cmd>set number!<cr>", desc = "Toggle Line Numbers" },

        -- Toggle word wrap for long lines
        ["<Leader>tw"] = { "<cmd>set wrap!<cr>", desc = "Toggle Word Wrap" },

        -- Center screen after search
        ["n"] = { "nzzzv", desc = "Next search result (centered)" },
        ["N"] = { "Nzzzv", desc = "Previous search result (centered)" },

        -- Better window navigation
        ["<C-h>"] = { "<C-w>h", desc = "Move to left window" },
        ["<C-j>"] = { "<C-w>j", desc = "Move to bottom window" },
        ["<C-k>"] = { "<C-w>k", desc = "Move to top window" },
        ["<C-l>"] = { "<C-w>l", desc = "Move to right window" },

        -- Quick buffer switching (like browser tabs)
        ["<S-l>"] = { "<cmd>bnext<cr>", desc = "Next buffer" },
        ["<S-h>"] = { "<cmd>bprevious<cr>", desc = "Previous buffer" },

        -- Quick reference guide
        ["<Leader>?"] = {
          function()
            vim.cmd("edit " .. vim.fn.stdpath("config") .. "/QUICK_REFERENCE.md")
          end,
          desc = "Open Quick Reference Guide"
        },

        -- Changelog and documentation
        ["<Leader>cl"] = {
          function()
            vim.cmd("edit " .. vim.fn.stdpath("config") .. "/CHANGELOG.md")
          end,
          desc = "Open Changelog & Usage Guide"
        },
      },
      v = {
        -- Snippets/Cheatsheets - save visual selection
        ["<Leader>s"] = { desc = "📚 Snippets/Cheatsheets" },
        ["<Leader>ss"] = { "<cmd>SnippetSaveMd<cr>", desc = "Save as Markdown" },
        ["<Leader>sj"] = { "<cmd>SnippetSaveJson<cr>", desc = "Save as JSON" },
      },
      i = {
        -- ============ BEGINNER-FRIENDLY INSERT MODE ============
        -- jj to escape (much easier than reaching for Esc)
        ["jj"] = { "<Esc>", desc = "Exit insert mode" },

        -- Ctrl+S to save while typing
        ["<C-s>"] = { "<Esc><cmd>w<cr>a", desc = "Save and continue editing" },

        -- Quick movements in insert mode
        ["<C-h>"] = { "<Left>", desc = "Move left" },
        ["<C-j>"] = { "<Down>", desc = "Move down" },
        ["<C-k>"] = { "<Up>", desc = "Move up" },
        ["<C-l>"] = { "<Right>", desc = "Move right" },

        -- Quick word navigation
        ["<C-b>"] = { "<C-Left>", desc = "Move word backward" },
        ["<C-f>"] = { "<C-Right>", desc = "Move word forward" },

        -- Delete word backward (like in most editors)
        ["<C-BS>"] = { "<C-w>", desc = "Delete word backward" },
      },
    },
  },
}
