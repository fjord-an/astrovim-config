if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Dashboard configuration for beginner-friendly welcome screen
return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = function()
    local logo = [[
      ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
      ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
      ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
      ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
      ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
      ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝
                    📝 Note-Taking Mode 📝
    ]]

    logo = string.rep("\n", 8) .. logo .. "\n\n"

    local opts = {
      theme = "doom",
      hide = {
        statusline = false,
      },
      config = {
        header = vim.split(logo, "\n"),
        center = {
          {
            action = "ObsidianNew",
            desc = " New Note",
            icon = " ",
            key = "n",
          },
          {
            action = "ObsidianQuickSwitch",
            desc = " Quick Switch",
            icon = " ",
            key = "o",
          },
          {
            action = "ObsidianSearch",
            desc = " Search Notes",
            icon = " ",
            key = "s",
          },
          {
            action = "ObsidianToday",
            desc = " Today's Note",
            icon = " ",
            key = "t",
          },
          {
            action = "Telescope find_files",
            desc = " Find Files",
            icon = " ",
            key = "f",
          },
          {
            action = "edit " .. vim.fn.stdpath("config") .. "/QUICK_REFERENCE.md",
            desc = " Quick Reference",
            icon = " ",
            key = "?",
          },
          {
            action = "ZenMode",
            desc = " Focus Mode",
            icon = " ",
            key = "z",
          },
          {
            action = "Lazy",
            desc = " Lazy",
            icon = "󰒲 ",
            key = "l",
          },
          {
            action = "qa",
            desc = " Quit",
            icon = " ",
            key = "q",
          },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return {
            "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
            "",
            "💡 Tips: Press SPACE for commands • Type 'jj' to exit insert mode • Ctrl+S to save",
            "📖 Press '?' for the complete quick reference guide",
          }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardLoaded",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    return opts
  end,
}