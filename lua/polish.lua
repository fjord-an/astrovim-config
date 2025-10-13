-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
vim.filetype.add {
  extension = {
    foo = "fooscript",
  },
  filename = {
    ["Foofile"] = "fooscript",
  },
  pattern = {
    ["~/%.config/foo/.*"] = "fooscript",
  },
}

-- Augment keybinds are now defined in lua/plugins/astrocore.lua

-- ============================================================================
-- Cheatsheets/Snippets Manager Commands
-- ============================================================================
local cs = require("user.cheatsheets")

-- Save visual selection as Markdown cheatsheet
vim.api.nvim_create_user_command("SnippetSaveMd", function()
  cs.save_selection_as_markdown()
end, { range = true, desc = "Save selection as Markdown cheatsheet" })

-- Save visual selection as JSON file
vim.api.nvim_create_user_command("SnippetSaveJson", function()
  cs.save_selection_as_json()
end, { range = true, desc = "Save selection as JSON snippet" })

-- Open Telescope picker in cheatsheets directory
vim.api.nvim_create_user_command("CheatsheetsOpen", function()
  cs.open_cheatsheets()
end, { desc = "Browse cheatsheets with Telescope" })

-- Live grep in cheatsheets directory
vim.api.nvim_create_user_command("CheatsheetsGrep", function()
  cs.cheatsheets_grep()
end, { desc = "Search cheatsheets with Telescope" })

-- Create new blank Markdown cheatsheet
vim.api.nvim_create_user_command("CheatsheetNew", function()
  cs.new_blank_markdown_cheatsheet()
end, { desc = "Create new blank cheatsheet" })

-- Live server commands for macOS with Floorp
do
  local state = { running = false, job_id = nil, port = 8080, browser_app = "Floorp" }
  local function notify(msg, level) vim.notify(msg, level or vim.log.levels.INFO) end
  local function ensure_file()
    local p = vim.fn.expand("%:p")
    if p == "" then
      notify("Buffer has no file on disk. Save it first.", vim.log.levels.ERROR)
      return nil
    end
    return p
  end
  vim.api.nvim_create_user_command("LiveServerStart", function()
    if state.running then notify("Live server already running", vim.log.levels.WARN); return end
    local file_path = ensure_file(); if not file_path then return end
    local file = vim.fn.fnamemodify(file_path, ":t")
    local dir = vim.fn.fnamemodify(file_path, ":h")
    local live_server_bin = "/opt/homebrew/bin/live-server"
    if vim.fn.filereadable(live_server_bin) == 0 then live_server_bin = "live-server" end
    state.job_id = vim.fn.jobstart({ live_server_bin, dir, "--port=" .. state.port, "--no-browser" }, {
      cwd = dir,
      on_exit = function()
        state.running = false
        state.job_id = nil
        notify("Live server stopped")
      end,
    })
    if state.job_id and state.job_id ~= 0 and state.job_id ~= -1 then
      state.running = true
      notify("Live server started on http://localhost:" .. state.port)
      vim.defer_fn(function()
        local url = "http://localhost:" .. state.port .. "/" .. file
        local ok = vim.fn.jobstart({ "open", "-a", state.browser_app, url })
        if not ok or ok == 0 or ok == -1 then vim.fn.jobstart({ "open", url }) end
      end, 800)
    else
      notify("Failed to start live-server. Install with: npm install -g live-server", vim.log.levels.ERROR)
      state.job_id = nil
    end
  end, {})
  vim.api.nvim_create_user_command("LiveServerStop", function()
    if not state.running then notify("Live server is not running", vim.log.levels.WARN); return end
    if state.job_id then vim.fn.jobstop(state.job_id) end
    state.running = false
    state.job_id = nil
  end, {})
  vim.api.nvim_create_user_command("LiveServerToggle", function()
    if state.running then vim.cmd("LiveServerStop") else vim.cmd("LiveServerStart") end
  end, {})
end

-- Live Server user commands (HTML dev workflow)
-- These are lightweight and only run when you call the commands.
local liveserver_running = false
local liveserver_job_id = nil

-- Start live-server with Floorp browser
vim.api.nvim_create_user_command("LiveServerStart", function()
  if liveserver_running then
    vim.notify("Live-server already running", vim.log.levels.WARN)
    return
  end

  local file = vim.fn.expand("%:p")
  local dir = vim.fn.expand("%:p:h")

  liveserver_job_id = vim.fn.jobstart(
    { "live-server", dir, "--port=8080", "--no-browser" },
    {
      on_exit = function()
        liveserver_running = false
        liveserver_job_id = nil
        vim.notify("Live-server stopped", vim.log.levels.INFO)
      end,
    }
  )

  if liveserver_job_id > 0 then
    liveserver_running = true
    vim.notify("Live-server started on http://localhost:8080", vim.log.levels.INFO)
    vim.defer_fn(function()
      vim.fn.jobstart({ "open", "-a", "Floorp", "http://localhost:8080/" .. vim.fn.fnamemodify(file, ":t") })
    end, 1000)
  else
    vim.notify("Failed to start live-server. Is it installed? (npm install -g live-server)", vim.log.levels.ERROR)
  end
end, {})

vim.api.nvim_create_user_command("LiveServerStop", function()
  if not liveserver_running then
    vim.notify("Live-server is not running", vim.log.levels.WARN)
    return
  end
  if liveserver_job_id then
    vim.fn.jobstop(liveserver_job_id)
    liveserver_running = false
    liveserver_job_id = nil
  end
end, {})

vim.api.nvim_create_user_command("LiveServerToggle", function()
  if liveserver_running then
    vim.cmd("LiveServerStop")
  else
    vim.cmd("LiveServerStart")
  end
end, {})
