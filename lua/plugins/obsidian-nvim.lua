return {
  -- Community fork of obsidian.nvim (actively maintained).
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = false,
  priority = 100,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim", -- required for picker.name = "telescope.nvim"
  },

  opts = {
    workspaces = {
      {
        name = "Brain",
        path = "/Users/jordan/Documents/3-Resources/Obsidian/brain-preservatives/brian-preservatives",
        strict = true,
      },
      {
        name = "Theology",
        path = "/Users/jordan/Documents/3-Resources/biblical-theology/",
        strict = true,
      },
    },

    notes_subdir = "notes",

    -- Use new-style commands (`:Obsidian today` etc.); legacy `:ObsidianToday` form removed in 4.0.
    legacy_commands = false,

    log_level = vim.log.levels.INFO,

    -- Link creation settings that match the Obsidian app.
    link = {
      style = "markdown",
      format = "shortest",
      auto_update = true,
    },

    daily_notes = {
      folder = "00-Daily Notes",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily-notes" },
      template = "nvim-daily",
    },

    templates = {
      folder = "Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {
        yesterday = function() return os.date("%Y-%m-%d", os.time() - 86400) end,
        tomorrow = function() return os.date("%Y-%m-%d", os.time() + 86400) end,
        day = function() return os.date "%A" end,
        week = function() return os.date "%Y-W%V" end,
        month = function() return os.date "%Y-%m" end,
      },
    },

    new_notes_location = "notes_subdir",

    frontmatter = {
      func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.title then
          note:add_alias(note.title)
        end
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
    },

    open_notes_in = "current",

    picker = {
      name = "telescope.nvim",
      note_mappings = {
        new = "<C-x>",
        insert_link = "<C-l>",
      },
      tag_mappings = {
        tag_note = "<C-x>",
        insert_tag = "<C-l>",
      },
    },

    search = {
      sort_by = "modified",
      sort_reversed = true,
      max_lines = 1000,
    },

    callbacks = {
      enter_note = function()
        vim.keymap.set("n", "gf", function()
          if require("obsidian.api").cursor_link() then
            return "<cmd>Obsidian follow_link<cr>"
          else
            return "gf"
          end
        end, { noremap = false, expr = true, buffer = true, desc = "Follow link or gf" })
        vim.keymap.set("n", "<leader>ch", "<cmd>Obsidian toggle_checkbox<cr>", { buffer = true, desc = "Toggle checkbox" })
      end,
    },

    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,

    checkbox = {
      order = { " ", "x", ">", "~", "!" },
    },

    ui = {
      enable = true,
      update_debounce = 200,
      max_file_length = 5000,
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },

    attachments = {
      folder = "assets/imgs",
    },
  },
}
