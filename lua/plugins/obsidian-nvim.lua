return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = false,
  priority = 100,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "Brain",
        path = "/Users/jordan/Documents/3-Resources/Obsidian/brain-preservatives/brian-preservatives",
        strict = true,
      },
    },

    notes_subdir = "notes",

    log_level = vim.log.levels.INFO,

    completion = {
      nvim_cmp = true,
      min_chars = 2,
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

    note_frontmatter_func = function(note)
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

    follow_url_func = function(url) vim.fn.jobstart { "open", url } end,

    preferred_link_style = "wiki",

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

    sort_by = "modified",
    sort_reversed = true,

    search_max_lines = 1000,

    mappings = {
      ["gf"] = {
        action = function() return require("obsidian").util.gf_passthrough() end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<leader>ch"] = {
        action = function() return require("obsidian").util.toggle_checkbox() end,
        opts = { buffer = true },
      },
      ["<cr>"] = {
        action = function() return require("obsidian").util.smart_action() end,
        opts = { buffer = true, expr = true },
      },
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

    ui = {
      enable = true,
      update_debounce = 200,
      max_file_length = 5000,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
      },
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
      img_folder = "assets/imgs",
    },
  },
}