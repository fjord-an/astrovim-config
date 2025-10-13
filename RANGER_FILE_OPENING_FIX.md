# Ranger File Opening Behavior Fix

## Problem
When opening files from ranger (via rnvimr plugin), files were opening **inside** the ranger terminal window instead of:
1. Closing ranger
2. Opening the file in the main Neovim buffer/pane

## Root Cause
The `rifle.conf` was configured to use a custom alternating split script, which was opening files in new splits but **not closing ranger**. This caused:
- Ranger to stay open in a terminal buffer
- Files to appear to open "inside" ranger
- Confusion about which buffer had focus

## Solution Applied

### 1. Updated `~/.config/ranger/rifle.conf`

**Changed default behavior from:**
```bash
env NVIM, ext xml|json... = ~/.config/nvim/scripts/ranger-open-alternating.sh "$@"
```

**To:**
```bash
env NVIM, ext xml|json... = nvim --server "$NVIM" --remote "$@"
```

### 2. What This Does

The `nvim --remote` command:
1. **Sends the file path back to the parent Neovim instance**
2. **Closes the ranger terminal buffer automatically**
3. **Opens the file in the current window** (the buffer you had before opening ranger)

This is the standard behavior for file pickers - they close when you select a file, and the file opens where you were working.

---

## New Behavior

### Default File Opening (Press `Enter` in Ranger)

```
1. You're editing file.txt
2. Press <Space>er to open ranger
3. Navigate to another-file.txt
4. Press Enter
5. Ranger closes
6. another-file.txt opens in the SAME window where file.txt was
```

### Alternative Opening Methods

You can still use custom keybindings **within ranger** for different behavior:

| Keybinding | Action | Behavior |
|------------|--------|----------|
| `Enter` | Default open | Opens in current window, closes ranger |
| `:open_with tab` | Open in tab | Opens in new tab, closes ranger |
| `:open_with vsplit` | Vertical split | Opens in vertical split, closes ranger |
| `:open_with hsplit` | Horizontal split | Opens in horizontal split, closes ranger |
| `<C-t>` | Tab (rnvimr action) | Opens in new tab (via rnvimr) |
| `<C-x>` | Hsplit (rnvimr action) | Opens in horizontal split (via rnvimr) |
| `<C-v>` | Vsplit (rnvimr action) | Opens in vertical split (via rnvimr) |

---

## Configuration Details

### rifle.conf Settings

**File:** `~/.config/ranger/rifle.conf`

```bash
# Default: Open in current window (ranger closes)
env NVIM, ext xml|json|tex|py|pl|rb|js|sh|php|m[ark]d[own]|txt|lua|rs|go|ts|tsx|jsx|c|cpp|h|hpp|css|scss|yaml|yml|toml|ini|conf = nvim --server "$NVIM" --remote "$@"
env NVIM, mime ^text = nvim --server "$NVIM" --remote "$@"

# Alternative: Open in new tab (use :open_with tab)
env NVIM, ext ..., label tab = nvim --server "$NVIM" --remote-tab "$@"

# Alternative: Open in vsplit (use :open_with vsplit)
env NVIM, ext ..., label vsplit = nvim --server "$NVIM" --remote-send "<Esc>:vsplit $@<CR>"

# Alternative: Open in hsplit (use :open_with hsplit)
env NVIM, ext ..., label hsplit = nvim --server "$NVIM" --remote-send "<Esc>:split $@<CR>"
```

### rnvimr Plugin Settings

**File:** `~/.config/nvim/lua/plugins/user.lua`

```lua
vim.g.rnvimr_action = {
  ['<C-t>'] = 'NvimEdit tabedit',  -- Ctrl+T in ranger opens in new tab
  ['<C-x>'] = 'NvimEdit split',    -- Ctrl+X in ranger opens in horizontal split
  ['<C-v>'] = 'NvimEdit vsplit',   -- Ctrl+V in ranger opens in vertical split
  ['gw'] = 'JumpNvimCwd',          -- gw jumps to Neovim's CWD
  ['yw'] = 'EmitRangerCwd'         -- yw syncs ranger CWD to Neovim
}
```

---

## Testing

### Test 1: Basic File Opening
```
1. Open Neovim: nvim
2. Press <Space>er to open ranger
3. Navigate to a file
4. Press Enter
5. Expected: Ranger closes, file opens in current buffer
```

### Test 2: Open in New Tab
```
1. In ranger, navigate to a file
2. Type: :open_with tab
3. Press Enter
4. Expected: Ranger closes, file opens in new tab
```

### Test 3: Open in Split
```
1. In ranger, navigate to a file
2. Press: <C-v> (or use :open_with vsplit)
3. Expected: Ranger closes, file opens in vertical split
```

---

## Understanding the Commands

### `nvim --remote`
- Sends file to existing Neovim instance
- Opens in **current window** (replaces current buffer)
- Closes ranger automatically

### `nvim --remote-tab`
- Sends file to existing Neovim instance
- Opens in **new tab**
- Closes ranger automatically

### `nvim --remote-send "<Esc>:split file<CR>"`
- Sends raw commands to Neovim
- Opens in **new split**
- More control but requires escaping special characters

---

## Why This Is Better

### Old Behavior (Alternating Splits Script)
- ❌ Ranger stayed open after file selection
- ❌ Files opened "somewhere" in splits
- ❌ Lost focus and context
- ❌ Confusing which buffer had focus
- ❌ Required manual ranger closing (`q`)

### New Behavior (Remote Command)
- ✅ Ranger closes automatically
- ✅ File opens exactly where you were working
- ✅ Clear focus and context
- ✅ Standard file picker behavior
- ✅ Clean and predictable

---

## If You Want Different Default Behavior

### Option A: Always Open in Vertical Split

Edit `~/.config/ranger/rifle.conf`, line ~62:
```bash
# Change from:
env NVIM, ext ... = nvim --server "$NVIM" --remote "$@"

# To:
env NVIM, ext ... = nvim --server "$NVIM" --remote-send "<Esc>:vsplit $@<CR>"
```

### Option B: Always Open in New Tab

```bash
# Change to:
env NVIM, ext ... = nvim --server "$NVIM" --remote-tab "$@"
```

### Option C: Restore Alternating Splits

```bash
# Change to:
env NVIM, ext ... = ~/.config/nvim/scripts/ranger-open-alternating.sh "$@"
```

**Note:** With alternating splits, you'll need to manually close ranger with `q`.

---

## Troubleshooting

### Issue: Ranger Still Not Closing

**Cause:** Neovim server might not be receiving the command.

**Solution:**
```bash
# Check NVIM variable is set in ranger
# In ranger, press Shift+! to enter shell and type:
echo $NVIM

# Should output something like: /var/folders/.../nvim.12345.0
# If empty, rnvimr is not setting it properly
```

### Issue: File Opens but Ranger Stays Open

**Cause:** Using custom script instead of `--remote` command.

**Solution:**
1. Check `~/.config/ranger/rifle.conf` lines 62-63
2. Ensure they use `nvim --server "$NVIM" --remote "$@"`
3. Restart ranger

### Issue: Multiple Files Open in Wrong Order

**Cause:** Selecting multiple files in ranger.

**Behavior:** All selected files open, but order might be unexpected.

**Solution:** Select files one at a time, or use tabs:
```bash
# In rifle.conf, for multiple files:
env NVIM, ext ... = nvim --server "$NVIM" --remote-tab-silent "$@"
```

---

## Related Files

- **Ranger file opener config:** `~/.config/ranger/rifle.conf`
- **Rnvimr plugin config:** `~/.config/nvim/lua/plugins/user.lua`
- **Alternating split script:** `~/.config/nvim/scripts/ranger-open-alternating.sh` (not used by default anymore)
- **Main ranger guide:** `~/.config/nvim/RANGER_NEOVIM_GUIDE.md`

---

## Summary

**Problem:** Files opened "inside" ranger instead of in the main Neovim buffer.

**Root Cause:** rifle.conf was using a custom script that didn't close ranger.

**Solution:** Changed to use `nvim --remote` which:
- Sends file back to Neovim
- Closes ranger automatically
- Opens file in current window (standard behavior)

**Result:** Ranger now behaves like a proper file picker - closes when you select a file, and the file opens where you expect it.

---

## Changelog

- **2025-10-13**: Changed default file opening behavior
  - Replaced custom alternating script with `nvim --remote`
  - Ranger now closes automatically when files are opened
  - Files open in current buffer (expected behavior)
  - Custom split/tab options still available via `:open_with` labels

---

*Fixed: 2025-10-13*
*Related Fix: RNVIMR_FIX_GUIDE.md (E216 autocommand error)*
