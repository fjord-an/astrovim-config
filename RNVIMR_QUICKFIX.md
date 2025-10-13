# Rnvimr E216 Error - Quick Fix Summary

## The Problem
```
E216: No such group or event: RnvimrTerm TermEnter
```

## The Solution
**One-line explanation:** Created the `RnvimrTerm` autocommand group before the plugin tries to use it.

## What Was Changed
File: `~/.config/nvim/lua/plugins/user.lua`

### Before:
```lua
{
  "kevinhwang91/rnvimr",
  config = function()
    vim.g.rnvimr_draw_border = 1
    -- ... settings
  end,
}
```

### After:
```lua
{
  "kevinhwang91/rnvimr",
  init = function()
    -- Settings moved here (run BEFORE plugin loads)
    vim.g.rnvimr_draw_border = 1
    -- ... settings
    
    -- FIX: Create autocommand group early
    vim.api.nvim_create_augroup('RnvimrTerm', { clear = true })
  end,
  config = function()
    -- Additional config if needed
  end,
}
```

## Why This Works
- `init` runs **before** plugin loads
- `config` runs **after** plugin loads
- By creating the autocommand group in `init`, it exists when rnvimr needs it

## Testing
```bash
# Open Neovim
nvim

# Test ranger
:RnvimrToggle

# Or use keybinding
<Space>er
```

## If Still Not Working
1. **Restart Neovim completely**
2. **Check ranger is installed:** `which ranger`
3. **Check for other errors:** `:messages` in Neovim
4. **See full guide:** `~/.config/nvim/RNVIMR_FIX_GUIDE.md`

## Keybindings
| Key | Action |
|-----|--------|
| `<Space>er` | Toggle Ranger |
| `<Space>es` | Ranger with current file selected |
| `<C-t>` (in ranger) | Open in new tab |
| `<C-x>` (in ranger) | Open in horizontal split |
| `<C-v>` (in ranger) | Open in vertical split |

---
*Fixed: 2025-10-13*
