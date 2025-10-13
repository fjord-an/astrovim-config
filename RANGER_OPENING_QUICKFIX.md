# Ranger File Opening - Quick Fix

## The Problem
Files were opening **inside ranger's window** instead of in the main Neovim buffer.

## The Solution
Changed `rifle.conf` to use `nvim --remote` instead of custom script.

## What Changed

**File:** `~/.config/ranger/rifle.conf` (line ~62)

**Before:**
```bash
env NVIM, ext ... = ~/.config/nvim/scripts/ranger-open-alternating.sh "$@"
```

**After:**
```bash
env NVIM, ext ... = nvim --server "$NVIM" --remote "$@"
```

## New Behavior

1. Open ranger: `<Space>er`
2. Navigate to a file
3. Press `Enter`
4. **Ranger closes automatically**
5. **File opens in your current buffer**

This is standard file picker behavior!

## Alternative Opening Options

**Inside Ranger:**
- `Enter` - Open in current window (ranger closes)
- `<C-t>` - Open in new tab
- `<C-v>` - Open in vertical split  
- `<C-x>` - Open in horizontal split
- `:open_with tab` - Open in new tab
- `:open_with vsplit` - Open in vertical split
- `:open_with hsplit` - Open in horizontal split

## Testing

```bash
# Open Neovim
nvim

# Open ranger
<Space>er

# Navigate and press Enter
# Expected: Ranger closes, file opens in main buffer ✓
```

---

**Full Guide:** `~/.config/nvim/RANGER_FILE_OPENING_FIX.md`
**Fixed:** 2025-10-13
