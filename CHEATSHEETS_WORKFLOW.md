# Cheatsheets/Snippets Workflow Guide

Quick reference for saving and managing code snippets in your Obsidian cheatsheets folder.

## 📁 Target Directory

All snippets are saved to:
```
/Users/jordan/Library/Mobile Documents/iCloud~md~obsidian/Documents/brain-preservatives/brain-preservatives-MAIN/3-Resources/Developer-Tools-Cheatsheets
```

## 🎯 Quick Start

### Save Code as Markdown Cheatsheet
1. Visual select the code you want to save
2. Press `<leader>ss` (or `:SnippetSaveMd`)
3. Enter a title (defaults to first line of selection)
4. Enter the language (defaults to current buffer filetype)
5. File is saved with YAML frontmatter and fenced code block
6. Selection is copied to your clipboard automatically

### Save JSON Snippet
1. Visual select JSON content
2. Press `<leader>sj` (or `:SnippetSaveJson`)
3. Enter a title
4. File is saved as `.json`
5. You'll be warned if it's not valid JSON (but it saves anyway)
6. Selection is copied to your clipboard automatically

### Browse Cheatsheets
- Press `<leader>so` to open Telescope file picker in your cheatsheets directory
- Navigate with `j`/`k`, open with `<CR>`

### Search Cheatsheets
- Press `<leader>sg` to live grep across all cheatsheets
- Type your search term and results update in real-time

### Create New Blank Cheatsheet
- Press `<leader>sn` to create a blank cheatsheet template
- Enter a title
- Opens with YAML frontmatter and empty fenced code block (language = current buffer filetype)

## 📋 Commands

| Command | Description |
|---------|-------------|
| `:SnippetSaveMd` | Save visual selection as Markdown cheatsheet |
| `:SnippetSaveJson` | Save visual selection as JSON file |
| `:CheatsheetsOpen` | Browse cheatsheets with Telescope |
| `:CheatsheetsGrep` | Search cheatsheets with Telescope |
| `:CheatsheetNew` | Create new blank cheatsheet |

## ⌨️ Keybindings

### Visual Mode
| Key | Action |
|-----|--------|
| `<leader>ss` | Save selection as Markdown cheatsheet |
| `<leader>sj` | Save selection as JSON file |

### Normal Mode
| Key | Action |
|-----|--------|
| `<leader>so` | Open cheatsheets (Telescope) |
| `<leader>sg` | Search/grep cheatsheets (Telescope) |
| `<leader>sn` | Create new blank cheatsheet |

## 📝 File Format

### Markdown Cheatsheets
Files are saved as: `YYYYMMDD-HHMMSS-slug.md`

Example:
```markdown
---
id: 20250113-152034-git-rebase-interactive
title: Git Rebase Interactive
created: 2025-01-13T15:20:34+1100
tags: [cheatsheet, snippet]
---

```bash
git rebase -i HEAD~3
```
\```

### JSON Files
Files are saved as: `YYYYMMDD-HHMMSS-slug.json`

Raw content is saved exactly as selected (no wrapper or formatting).

## 🔧 Features

- **Automatic clipboard copying**: Selection is always copied to system clipboard
- **Smart defaults**: 
  - Title defaults to first line of selection or current filename
  - Language defaults to current buffer filetype
- **Filesystem-safe slugs**: Titles are normalized to safe filenames
- **Timestamped filenames**: Easy to sort and find recent snippets
- **YAML frontmatter**: Compatible with Obsidian and other knowledge bases
- **Directory auto-creation**: Target directory is created if it doesn't exist
- **Error handling**: Friendly notifications for any issues

## 🎨 Workflow Examples

### Example 1: Save a Bash command
```bash
# In any buffer with bash code
# Visual select these lines:
find . -name "*.log" -mtime +30 -delete
du -sh * | sort -h

# Press <leader>ss
# Title: "Clean old logs and check disk usage"
# Language: bash
# → Saved to: 20250113-152034-clean-old-logs-and-check-disk-usage.md
```

### Example 2: Save a JSON config
```json
{
  "eslint.enable": true,
  "prettier.enable": true
}

# Visual select the JSON
# Press <leader>sj
# Title: "VSCode settings"
# → Saved to: 20250113-152135-vscode-settings.json
```

### Example 3: Browse and copy from saved snippets
```
# Press <leader>so
# Find your snippet in Telescope
# Open it, yank the code block
# Or press <leader>sg to search by content
```

## 🚀 Pro Tips

1. **Quick capture**: You can chain commands. Select → `<leader>ss` → just press Enter twice to accept defaults
2. **Clipboard ready**: After saving, your selection is in the clipboard. Cmd+V to paste anywhere
3. **Search first**: Use `<leader>sg` to check if you already have a similar snippet before saving
4. **Obsidian sync**: Files are in your Obsidian vault and will sync via iCloud
5. **Manual editing**: All files are plain text. Edit them directly in Neovim or Obsidian

## 🐛 Troubleshooting

### "No visual selection" error
- Make sure you're in Visual mode and have text selected
- The commands need to be run while/after selecting text

### "Telescope is not available" error
- This shouldn't happen in AstroNvim, but if it does, Telescope isn't loaded
- Try `:Lazy sync` to update plugins

### Files not appearing in Obsidian
- Check if iCloud sync is working
- The path is quite long; verify it exists: `:!ls -la "<path>"`

### Can't find keybinding
- Your leader key is likely Space (default in AstroNvim)
- Try `:WhichKey <leader>s` to see all snippet-related bindings

## 📚 Related

- Main Neovim config: `~/.config/nvim/`
- Module implementation: `~/.config/nvim/lua/user/cheatsheets.lua`
- Commands: `~/.config/nvim/lua/polish.lua`
- Keybindings: `~/.config/nvim/lua/plugins/astrocore.lua`

---

**Last updated**: 2025-01-13  
**Version**: 1.0.0
