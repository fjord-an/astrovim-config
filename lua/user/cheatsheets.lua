-- Cheatsheets/Snippets Manager for Neovim
-- Saves visual selections to Obsidian cheatsheets directory
-- Supports Markdown with fenced code blocks and raw JSON files

local M = {}

-- Target directory for cheatsheets/snippets
M.CHEATSHEETS_DIR = "/Users/jordan/Documents/3-Resources/Obsidian/brain-preservatives/brian-preservatives/3-Resources/Developer-Tools-Cheatsheets"

-- ============================================================================
-- Internal Helpers
-- ============================================================================

-- Ensure the cheatsheets directory exists
local function ensure_dir()
  vim.fn.mkdir(M.CHEATSHEETS_DIR, "p")
end

-- Write text to a file (creates directory if needed)
local function write_file(path, text)
  ensure_dir()
  local f, err = io.open(path, "w")
  if not f then
    return nil, err
  end
  f:write(text)
  f:close()
  return true
end

-- Get current time in ISO 8601 format
local function now_iso()
  return os.date("%Y-%m-%dT%H:%M:%S%z")
end

-- Get timestamp for filenames (YYYYMMDD-HHMMSS)
local function stamp()
  return os.date("%Y%m%d-%H%M%S")
end

-- Make internal helpers accessible for testing
M._ensure_dir = ensure_dir
M._write_file = write_file
M._now_iso = now_iso
M._stamp = stamp

-- ============================================================================
-- Public Utility Functions
-- ============================================================================

-- Convert title to filesystem-safe slug
function M.slugify(title)
  title = title or ""
  local s = title:lower()
  -- Replace non-word characters with hyphen
  s = s:gsub("[^%w]+", "-")
  -- Collapse multiple hyphens
  s = s:gsub("%-+", "-")
  -- Trim leading/trailing hyphens
  s = s:gsub("^%-", ""):gsub("%-$", "")
  -- Fallback if empty
  if s == "" then
    s = "snippet"
  end
  return s
end

-- Get the current visual selection
function M.get_visual_selection()
  local s = vim.fn.getpos("'<")
  local e = vim.fn.getpos("'>")
  local bufnr = 0
  local start_row = s[2] - 1
  local start_col = s[3] - 1
  local end_row = e[2] - 1
  local end_col = e[3]
  
  -- Validate selection
  if start_row > end_row or (start_row == end_row and start_col >= end_col) then
    return ""
  end
  
  -- Extract text from buffer
  local lines = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})
  return table.concat(lines, "\n")
end

-- ============================================================================
-- Main Save Functions
-- ============================================================================

-- Save visual selection as Markdown with YAML frontmatter and fenced code block
function M.save_selection_as_markdown(opts)
  opts = opts or {}
  
  -- Get selection
  local sel = M.get_visual_selection()
  if not sel or sel == "" then
    vim.notify("No visual selection", vim.log.levels.WARN)
    return
  end
  
  -- Get current filetype for language default
  local ft = vim.bo.filetype ~= "" and vim.bo.filetype or "txt"
  
  -- Extract first line for default title
  local first_line = sel:match("([^\n]*)") or ""
  first_line = first_line:gsub("^%s+", ""):gsub("%s+$", "")
  
  -- Default title from first line or current buffer name
  local default_title = #first_line > 0 and first_line or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  if default_title == "" then
    default_title = "Code Snippet"
  end
  
  -- Prompt for title
  local title = vim.fn.input("Cheatsheet title: ", default_title)
  if title == "" then
    title = default_title
  end
  
  -- Prompt for language
  local lang_default = ft
  local lang = vim.fn.input("Language: ", lang_default)
  if lang == "" then
    lang = lang_default
  end
  
  -- Build filename
  local slug = M.slugify(title)
  local ts = M._stamp()
  local filename = ts .. "-" .. slug .. ".md"
  local path = M.CHEATSHEETS_DIR .. "/" .. filename
  
  -- Build YAML frontmatter
  local fm = table.concat({
    "---",
    "id: " .. ts .. "-" .. slug,
    "title: " .. title,
    "created: " .. M._now_iso(),
    "tags: [cheatsheet, snippet]",
    "---",
    ""
  }, "\n")
  
  -- Build fenced code block
  local body = "```" .. lang .. "\n" .. sel .. "\n```\n"
  
  -- Write file
  local ok, err = M._write_file(path, fm .. body)
  if not ok then
    vim.notify("Failed to write markdown: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  
  -- Copy selection to clipboard
  vim.fn.setreg("+", sel)
  
  -- Notify success
  vim.notify("✓ Saved markdown cheatsheet: " .. filename, vim.log.levels.INFO)
  
  -- Optional: open the file
  local open = vim.fn.input("Open now? (y/N): ")
  if open:lower() == "y" then
    vim.cmd.edit(path)
  end
end

-- Save visual selection as raw JSON file
function M.save_selection_as_json(opts)
  opts = opts or {}
  
  -- Get selection
  local sel = M.get_visual_selection()
  if not sel or sel == "" then
    vim.notify("No visual selection", vim.log.levels.WARN)
    return
  end
  
  -- Extract first line for default title
  local first_line = sel:match("([^\n]*)") or ""
  first_line = first_line:gsub("^%s+", ""):gsub("%s+$", "")
  local default_title = #first_line > 0 and first_line or "snippet"
  
  -- Prompt for title
  local title = vim.fn.input("JSON title: ", default_title)
  if title == "" then
    title = default_title
  end
  
  -- Build filename
  local slug = M.slugify(title)
  local ts = M._stamp()
  local filename = ts .. "-" .. slug .. ".json"
  local path = M.CHEATSHEETS_DIR .. "/" .. filename
  
  -- Write file
  local ok, err = M._write_file(path, sel)
  if not ok then
    vim.notify("Failed to write json: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  
  -- Validate JSON (best effort, warn if invalid but still save)
  local valid = pcall(vim.fn.json_decode, sel)
  local msg = "✓ Saved JSON cheatsheet: " .. filename
  if not valid then
    msg = msg .. " ⚠ (content may not be valid JSON)"
  end
  
  -- Copy selection to clipboard
  vim.fn.setreg("+", sel)
  
  -- Notify success
  vim.notify(msg, vim.log.levels.INFO)
  
  -- Optional: open the file
  local open = vim.fn.input("Open now? (y/N): ")
  if open:lower() == "y" then
    vim.cmd.edit(path)
  end
end

-- ============================================================================
-- Telescope Integration
-- ============================================================================

-- Open Telescope file picker in cheatsheets directory
function M.open_cheatsheets()
  local ok, tb = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("Telescope is not available", vim.log.levels.ERROR)
    return
  end
  
  tb.find_files({
    cwd = M.CHEATSHEETS_DIR,
    hidden = true,
    prompt_title = "📚 Cheatsheets & Snippets"
  })
end

-- Live grep within cheatsheets directory
function M.cheatsheets_grep()
  local ok, tb = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("Telescope is not available", vim.log.levels.ERROR)
    return
  end
  
  tb.live_grep({
    cwd = M.CHEATSHEETS_DIR,
    prompt_title = "🔍 Search Cheatsheets"
  })
end

-- ============================================================================
-- Blank Template Creation
-- ============================================================================

-- Create a new blank Markdown cheatsheet with fenced code block
function M.new_blank_markdown_cheatsheet()
  -- Get current filetype for the fence
  local ft = vim.bo.filetype ~= "" and vim.bo.filetype or "txt"
  
  -- Prompt for title
  local title = vim.fn.input("New cheatsheet title: ", "")
  if title == "" then
    vim.notify("Cancelled", vim.log.levels.WARN)
    return
  end
  
  -- Build filename
  local slug = M.slugify(title)
  local ts = M._stamp()
  local filename = ts .. "-" .. slug .. ".md"
  local path = M.CHEATSHEETS_DIR .. "/" .. filename
  
  -- Build YAML frontmatter
  local fm = table.concat({
    "---",
    "id: " .. ts .. "-" .. slug,
    "title: " .. title,
    "created: " .. M._now_iso(),
    "tags: [cheatsheet, snippet]",
    "---",
    ""
  }, "\n")
  
  -- Build empty fenced code block
  local body = "```" .. ft .. "\n\n```\n"
  
  -- Write file
  local ok, err = M._write_file(path, fm .. body)
  if not ok then
    vim.notify("Failed to create markdown: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  
  -- Open the file
  vim.cmd.edit(path)
  
  -- Notify success
  vim.notify("✓ Created blank cheatsheet: " .. filename, vim.log.levels.INFO)
end

return M
