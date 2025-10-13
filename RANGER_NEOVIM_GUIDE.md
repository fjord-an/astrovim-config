# Ranger + Neovim Integration Guide

**Complete Configuration Reference for rnvimr & rifle.conf**

---

## Table of Contents

1. [Overview](#overview)
2. [How It Works](#how-it-works)
3. [File Locations](#file-locations)
4. [Keybindings Reference](#keybindings-reference)
5. [Configuration Options](#configuration-options)
6. [Customizing Split Behavior](#customizing-split-behavior)
7. [Rifle.conf Rules Explained](#rifleconf-rules-explained)
8. [Troubleshooting](#troubleshooting)
9. [Advanced Tweaks](#advanced-tweaks)

---

## Overview

This configuration integrates **ranger** (terminal file manager) into Neovim using the **rnvimr** plugin. Files opened from ranger will automatically open in Neovim with **alternating split behavior** (vsplit → hsplit → vsplit...).

### Key Features
- ✅ Alternating vertical/horizontal splits by default
- ✅ Manual control via labels (`:open_with tab`, `:open_with vsplit`, etc.)
- ✅ Current file navigation with `<leader>ec`
- ✅ Seamless integration between ranger and Neovim
- ✅ Multiple keybinding options for different workflows

---

## How It Works

### The Integration Flow

```
┌─────────────┐
│   Neovim    │
│  (AstroNvim)│
└──────┬──────┘
       │ <leader>er/ef/ec
       ↓
┌─────────────┐
│   rnvimr    │  ← Plugin that embeds ranger in Neovim
│  (floating) │
└──────┬──────┘
       │ Select file, press Enter
       ↓
┌─────────────┐
│ rifle.conf  │  ← Rules determine HOW to open the file
│   (ranger)  │
└──────┬──────┘
       │ Executes opener script
       ↓
┌──────────────────────┐
│ ranger-open-         │  ← Custom script for alternating
│ alternating.sh       │     split behavior
└──────┬───────────────┘
       │ nvim --server $NVIM --remote-send
       ↓
┌─────────────┐
│   Neovim    │  ← File opens in vsplit/hsplit
│ (new split) │
└─────────────┘
```

### Environment Variables

The integration relies on the `$NVIM` environment variable:
- **Set by rnvimr**: When ranger is launched from within Neovim
- **Used by rifle.conf**: To detect Neovim context and send files back
- **Format**: Socket address like `/var/folders/.../nvim.12345.0`

---

## File Locations

### Neovim Configuration Files
```
~/.config/nvim/
├── lua/plugins/
│   ├── user.lua              # rnvimr plugin configuration
│   └── astrocore.lua         # Keybinding definitions
├── scripts/
│   └── ranger-open-alternating.sh  # Alternating split logic
└── RANGER_NEOVIM_GUIDE.md    # This file
```

### Ranger Configuration Files
```
~/.config/ranger/
├── rifle.conf                # File opener rules
└── rc.conf                   # Ranger settings (optional)
```

---

## Keybindings Reference

### In Neovim (Normal Mode)

| Keybinding     | Action                              | Notes                          |
|----------------|-------------------------------------|--------------------------------|
| `<Space>er`    | Toggle Ranger                       | Opens in CWD                   |
| `<Space>ef`    | Toggle Ranger (alternative)         | Same as `<leader>er`           |
| `<Space>ec`    | Ranger with current file highlighted| Opens in current file's dir (search-based) |
| `<Space>es`    | Ranger with current file selected    | Exact selection via --selectfile |

### In Ranger (When Opened from Neovim)

| Keybinding     | Action                              | Behavior                       |
|----------------|-------------------------------------|--------------------------------|
| `Enter`        | Open file (default)                 | Alternating splits (v→h→v...)  |
| `<C-t>`        | Open in new tab                     | Manual override               |
| `<C-x>`        | Open in horizontal split            | Manual override               |
| `<C-v>`        | Open in vertical split              | Manual override               |
| `gw`           | Jump to Neovim's CWD                | Navigate to working directory  |
| `yw`           | Emit Ranger's CWD to Neovim         | Sync directories               |

### Manual Label Openers (In Ranger)

Type these in ranger's command mode (`:` key):

| Command                  | Behavior                              |
|--------------------------|---------------------------------------|
| `:open_with tab`         | Force open in new tab                 |
| `:open_with vsplit`      | Force open in vertical split          |
| `:open_with hsplit`      | Force open in horizontal split        |

---

## Configuration Options

### rnvimr Plugin Settings

Location: `~/.config/nvim/lua/plugins/user.lua`

```lua
vim.g.rnvimr_draw_border = 1           -- Draw border around ranger window
vim.g.rnvimr_pick_enable = 1           -- Enable file picking
vim.g.rnvimr_bw_enable = 1             -- Wipe buffer when file is deleted
vim.g.rnvimr_enable_ex = 1             -- Enable expand command
vim.g.rnvimr_enable_picker = 1         -- Enable file picker mode
vim.g.rnvimr_hide_gitignore = 0        -- Show .gitignore files (0=show, 1=hide)
vim.g.rnvimr_enable_bw = 1             -- Enable buffer wipe on delete
```

#### Action Mappings

```lua
vim.g.rnvimr_action = {
  ['<C-t>'] = 'NvimEdit tabedit',      -- Ctrl+T opens in tab
  ['<C-x>'] = 'NvimEdit split',        -- Ctrl+X opens in hsplit
  ['<C-v>'] = 'NvimEdit vsplit',       -- Ctrl+V opens in vsplit
  ['gw'] = 'JumpNvimCwd',              -- gw jumps to Neovim CWD
  ['yw'] = 'EmitRangerCwd'             -- yw syncs ranger CWD to Neovim
}
```

#### Custom Ranger Startup Command

```lua
vim.g.rnvimr_ranger_cmd = { 
  'ranger', 
  '--cmd=set show_hidden=true'         -- Show hidden files by default
}
```

**Other useful options:**
```lua
'--cmd=set preview_images=true'        -- Enable image previews
'--cmd=set colorscheme=jungle'         -- Set colorscheme
'--cmd=set sort=mtime'                 -- Sort by modification time
```

---

## Customizing Split Behavior

### Current Setup: Alternating Splits

Files open in this pattern:
1. First file → **Vertical split** (side-by-side)
2. Second file → **Horizontal split** (top-bottom)
3. Third file → **Vertical split** (cycle continues)

### How It Works

The script `~/.config/nvim/scripts/ranger-open-alternating.sh`:
1. Checks for state file: `/tmp/nvim_ranger_split_state_$$`
2. Reads last split type (vsplit or split)
3. Alternates to opposite split type
4. Saves new state for next file
5. Executes: `nvim --server $NVIM --remote-send "<Esc>:vsplit file.txt<CR>"`

### Changing Default Behavior

#### Option 1: Always Open in Tabs

Edit `~/.config/ranger/rifle.conf`, lines 62-63:

**Replace:**
```bash
env NVIM, ext xml|json|tex|py|pl|rb|js|sh|php|m[ark]d[own]|txt = ~/.config/nvim/scripts/ranger-open-alternating.sh "$@"
```

**With:**
```bash
env NVIM, ext xml|json|tex|py|pl|rb|js|sh|php|m[ark]d[own]|txt = nvim --server "$NVIM" --remote-tab "$@"
```

#### Option 2: Always Open in Vsplit

**Replace with:**
```bash
env NVIM, ext xml|json|tex|py|pl|rb|js|sh|php|m[ark]d[own]|txt = nvim --server "$NVIM" --remote-send "<Esc>:vsplit $@<CR>"
```

#### Option 3: Always Open in Hsplit

**Replace with:**
```bash
env NVIM, ext xml|json|tex|py|pl|rb|js|sh|php|m[ark]d[own]|txt = nvim --server "$NVIM" --remote-send "<Esc>:split $@<CR>"
```

#### Option 4: Custom Split Pattern

Edit `~/.config/nvim/scripts/ranger-open-alternating.sh`:

For **vsplit → vsplit → hsplit → repeat**:
```bash
# Around line 18, replace the logic:
if [ -f "$STATE_FILE" ]; then
    COUNT=$(cat "$STATE_FILE")
    COUNT=$((COUNT + 1))
    if [ $((COUNT % 3)) -eq 0 ]; then
        SPLIT_CMD="split"
    else
        SPLIT_CMD="vsplit"
    fi
    echo "$COUNT" > "$STATE_FILE"
else
    SPLIT_CMD="vsplit"
    echo "1" > "$STATE_FILE"
fi
```

---

## Rifle.conf Rules Explained

Location: `~/.config/ranger/rifle.conf`

### Rule Structure

```
condition1, condition2, ... = command
```

### Conditions Reference

| Condition          | Meaning                               | Example                        |
|--------------------|---------------------------------------|--------------------------------|
| `ext <regex>`      | File extension matches                | `ext md` (Markdown files)      |
| `mime <regex>`     | MIME type matches                     | `mime ^text` (Any text file)   |
| `env <variable>`   | Environment variable is set           | `env NVIM` (Inside Neovim)     |
| `has <program>`    | Program exists in $PATH               | `has nvim`                     |
| `label <name>`     | Manual invocation label               | `label tab` (`:open_with tab`) |
| `flag <f/r/t>`     | Special behavior flags                | `flag f` (Fork/background)     |

### Rule Priority

**Rules are evaluated top-to-bottom. First match wins.**

```
# Higher priority (checked first)
env NVIM, ext md = nvim --server "$NVIM" --remote-tab "$@"

# Lower priority (checked after)
ext md = nvim "$@"

# Fallback (matches everything)
else = open "$@"
```

### Current Text File Rules

```bash
# Priority 1: Alternating splits (default when in Neovim)
env NVIM, ext xml|json|tex|py|pl|rb|js|sh|php|m[ark]d[own]|txt = \
    ~/.config/nvim/scripts/ranger-open-alternating.sh "$@"

# Priority 2: Tab opener (manual: :open_with tab)
env NVIM, ext xml|json|tex|py|pl|rb|js|sh|php|m[ark]d[own]|txt, label tab = \
    nvim --server "$NVIM" --remote-tab "$@"

# Priority 3: Vsplit opener (manual: :open_with vsplit)
env NVIM, ext xml|json|tex|py|pl|rb|js|sh|php|m[ark]d[own]|txt, label vsplit = \
    nvim --server "$NVIM" --remote-send "<Esc>:vsplit<CR>:edit $@<CR>"

# Priority 4: Hsplit opener (manual: :open_with hsplit)
env NVIM, ext xml|json|tex|py|pl|rb|js|sh|php|m[ark]d[own]|txt, label hsplit = \
    nvim --server "$NVIM" --remote-send "<Esc>:split<CR>:edit $@<CR>"

# Priority 5: Standalone Neovim (when not in Neovim)
ext xml|json|tex|py|pl|rb|js|sh|php|m[ark]d[own]|txt = nvim "$@"
```

### Adding New File Types

To add support for a new extension (e.g., `.yaml`):

1. Edit `~/.config/ranger/rifle.conf`
2. Find the text file rules section (around line 60)
3. Add `|yaml` to each extension list:

```bash
env NVIM, ext xml|json|tex|py|pl|rb|js|sh|php|m[ark]d[own]|txt|yaml = ...
```

### Testing rifle.conf Rules

```bash
# Test which rule would match a file
rifle -l /path/to/file.txt

# Test specific label
rifle -p vsplit /path/to/file.txt
```

---

## Troubleshooting

### Files Don't Open in Neovim

**Symptoms:** Files open in external nvim instance or nothing happens

**Diagnosis:**
```bash
# From within Neovim's terminal:
echo $NVIM
# Should print: /var/folders/.../nvim.12345.0

# If empty, rnvimr isn't setting it properly
```

**Fix:**
1. Restart Neovim
2. Try `:RnvimrToggle` directly (not via keybinding)
3. Check rnvimr installation: `:Lazy sync`

### Alternating Splits Not Working

**Symptoms:** Files always open in tabs or same split type

**Diagnosis:**
```bash
# Check if script is executable
ls -la ~/.config/nvim/scripts/ranger-open-alternating.sh
# Should show: -rwxr-xr-x (x permission)

# Check if rifle.conf uses the script
grep "ranger-open-alternating" ~/.config/ranger/rifle.conf
```

**Fix:**
```bash
# Make script executable
chmod +x ~/.config/nvim/scripts/ranger-open-alternating.sh

# Verify rifle.conf points to correct path
# Edit line 62-63 to use full path
```

### Split Pattern Resets Every Session

**Expected Behavior:** The split state is session-specific (tied to `$$` = process ID)

**If you want persistent state:**

Edit `~/.config/nvim/scripts/ranger-open-alternating.sh`, line 6:
```bash
# Replace:
STATE_FILE="/tmp/nvim_ranger_split_state_$$"

# With:
STATE_FILE="/tmp/nvim_ranger_split_state_persistent"
```

### Ranger Keybindings Don't Work

**Symptoms:** `<C-t>`, `<C-v>`, `<C-x>` don't open files as expected

**Diagnosis:** Check if ranger is mapping those keys elsewhere

```bash
# Check ranger keybindings
ranger --list-keys | grep -E "C-[tvx]"
```

**Fix:** Add to `~/.config/ranger/rc.conf`:
```bash
# Unmap conflicting keys
unmap <C-t>
unmap <C-v>
unmap <C-x>
```

### Current File Selection (<leader>ec) Doesn't Work

**Symptoms:** `<leader>ec` opens ranger but doesn't highlight current file

**Current Implementation:** Uses search within ranger (`/filename`)

**Alternative Implementation:** Use ranger's `--selectfile` option

Edit `~/.config/nvim/lua/plugins/user.lua`, around line 164:
```lua
-- Replace the <leader>ec function with:
function()
  local current_file = vim.fn.expand('%:p')
  if current_file ~= '' then
    vim.g.rnvimr_ranger_cmd = { 
      'ranger', 
      '--selectfile=' .. current_file 
    }
    vim.cmd('RnvimrToggle')
    -- Reset to default after opening
    vim.defer_fn(function()
      vim.g.rnvimr_ranger_cmd = { 'ranger' }
    end, 500)
  else
    vim.cmd('RnvimrToggle')
  end
end
```

---

## Advanced Tweaks

### 1. Conditional Split Based on File Type

Edit `~/.config/nvim/scripts/ranger-open-alternating.sh`:

```bash
# Around line 33, before opening the file:
for file in "$@"; do
    # Determine split based on file extension
    case "${file##*.}" in
        md|txt)
            SPLIT_CMD="vsplit"  # Markdown always in vsplit
            ;;
        py|js|lua)
            SPLIT_CMD="split"   # Code always in hsplit
            ;;
        *)
            # Use alternating logic for others
            if [ -f "$STATE_FILE" ]; then
                LAST_SPLIT=$(cat "$STATE_FILE")
                [ "$LAST_SPLIT" = "vsplit" ] && SPLIT_CMD="split" || SPLIT_CMD="vsplit"
            else
                SPLIT_CMD="vsplit"
            fi
            ;;
    esac
    
    echo "$SPLIT_CMD" > "$STATE_FILE"
    nvim --server "$NVIM_SERVER" --remote-send "<Esc>:${SPLIT_CMD} ${file}<CR>"
done
```

### 2. Open Large Files in Tabs

Add size check to the script:

```bash
# Around line 33:
for file in "$@"; do
    # Check file size (in KB)
    FILESIZE=$(du -k "$file" | cut -f1)
    
    if [ "$FILESIZE" -gt 1000 ]; then
        # Files > 1MB open in tab
        nvim --server "$NVIM_SERVER" --remote-tab "$file"
    else
        # Normal alternating logic
        # ... existing code ...
    fi
done
```

### 3. Smart Split Based on Window Count

Open in split only if there's room:

```bash
# Add before opening:
WINDOW_COUNT=$(nvim --server "$NVIM_SERVER" --remote-expr "winnr('$')")

if [ "$WINDOW_COUNT" -ge 4 ]; then
    # Too many windows, use tab instead
    nvim --server "$NVIM_SERVER" --remote-tab "$file"
else
    # Normal split logic
    # ... existing code ...
fi
```

### 4. Preview Mode (Read-Only)

Add label in rifle.conf:

```bash
env NVIM, ext md|txt, label preview = \
    nvim --server "$NVIM" --remote-send "<Esc>:vsplit $@<CR>:setlocal readonly<CR>"
```

Usage in ranger: `:open_with preview file.txt`

### 5. Integration with Tmux Panes

If you use tmux, split ranger in tmux pane instead:

Add to `~/.config/nvim/lua/plugins/user.lua`:

```lua
-- Add new keybinding:
{ 
  "<leader>et", 
  function()
    vim.fn.system("tmux split-window -h ranger")
  end,
  desc = "Ranger in tmux pane" 
}
```

### 6. Conditional Behavior Based on Filetype

In `~/.config/nvim/lua/plugins/user.lua`, modify the rnvimr config:

```lua
config = function()
  -- Existing config...
  
  -- Auto-close ranger after opening certain filetypes
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text" },
    callback = function()
      -- Close ranger window if it's open
      if vim.fn.exists(":RnvimrResize") > 0 then
        vim.cmd("RnvimrToggle")
      end
    end,
  })
end
```

### 7. Ranger Color Scheme Matching Neovim

Add to ranger startup command:

```lua
vim.g.rnvimr_ranger_cmd = { 
  'ranger',
  '--cmd=set colorscheme=default'  -- or 'jungle', 'snow', etc.
}
```

Match it to your Neovim colorscheme for consistency.

---

## Quick Reference Card

### Open Files From Ranger
- **Enter** → Alternating split (default)
- **Ctrl+T** → New tab
- **Ctrl+V** → Vertical split (manual)
- **Ctrl+X** → Horizontal split (manual)

### In Ranger Command Mode (`:`)
- `:open_with tab` → Force tab
- `:open_with vsplit` → Force vsplit
- `:open_with hsplit` → Force hsplit

### Neovim Keybindings
- `<Space>er` → Open ranger (CWD)
- `<Space>ef` → Open ranger (alternative)
- `<Space>ec` → Open ranger (current file location)

### Testing & Debugging
```bash
# Check NVIM variable
echo $NVIM

# Test rifle rules
rifle -l /path/to/file.txt

# Check rnvimr status
:checkhealth rnvimr

# Reload rifle.conf (no restart needed)
# Just open ranger again - it auto-reloads
```

---

## Resources

- **rnvimr GitHub**: https://github.com/kevinhwang91/rnvimr
- **ranger Documentation**: https://github.com/ranger/ranger/wiki
- **rifle.conf Examples**: https://github.com/ranger/ranger/blob/master/ranger/config/rifle.conf
- **AstroNvim Docs**: https://docs.astronvim.com/

---

## Questions?

If you encounter issues not covered in this guide:

1. Check `:checkhealth` in Neovim
2. Verify `$NVIM` is set when opening ranger
3. Test rifle.conf rules with `rifle -l filename`
4. Check script permissions: `ls -la ~/.config/nvim/scripts/`
5. Review Neovim messages: `:messages`

---

**Last Updated:** 2025-10-13  
**Configuration Version:** AstroNvim 4.x + rnvimr + ranger 1.9.x
