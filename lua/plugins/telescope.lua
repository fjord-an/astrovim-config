return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        -- Added for better sorting and predictability
        sorting_strategy = "ascending",
        -- Added for better layout
        layout_config = {
          width = 0.9,
        },
        -- Use fzy sorter for better fuzzy matching
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        generic_sorter = require("telescope.sorters").get_fzy_sorter,
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<CR>"] = actions.select_default,
            -- Add more mappings here if needed, e.g., to toggle preview
          },
          n = {
            -- Normal mode mappings (e.g., for navigating in results)
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
          -- Include hidden files by default
          hidden = true,
        },
        live_grep = {
          theme = "dropdown",
          previewer = false,
        },
        -- Added useful pickers
        buffers = {
          theme = "dropdown",
          previewer = false,
        },
        oldfiles = {
          theme = "dropdown",
          previewer = false,
        },
        help_tags = {
          theme = "dropdown",
          previewer = false,
        },
        -- You can add more picker configurations here, e.g., for specific file types
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- "smart_case", "send_to_lower", "respect_case"
        },
        -- Git related pickers
        git_files = {
          theme = "dropdown",
          previewer = false,
          hidden = true,
        },
        git_bcommits = {
          theme = "dropdown",
          previewer = false,
        },
        git_branches = {
          theme = "dropdown",
          previewer = false,
        },
        git_status = {
          theme = "dropdown",
          previewer = false,
        },
        -- Undo history
        undo = {
          theme = "dropdown",
          previewer = false,
        },
      },
    })

    -- Setup keybindings for Telescope pickers
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "[F]ind [O]ldfiles" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
    -- Git pickers
    vim.keymap.set("n", "<leader>gc", function() require("telescope.builtin").git_commits() end, { desc = "Git [C]ommits" })
    vim.keymap.set("n", "<leader>gb", function() require("telescope.builtin").git_branches() end, { desc = "Git [B]ranches" })
    vim.keymap.set("n", "<leader>gs", function() require("telescope.builtin").git_status() end, { desc = "Git [S]tatus" })
    -- Undo history
    vim.keymap.set("n", "<leader>fu", function() require("telescope.builtin").undo() end, { desc = "[F]ind [U]ndo History" })
  end,
}