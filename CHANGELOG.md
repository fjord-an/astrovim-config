# Neovim Note-Taking Setup Changelog

## 🎯 What Was Added
This update transforms your AstroVim into a beginner-friendly note-taking powerhouse, making it as easy to use as any modern editor while retaining Vim's power.

---

## 📦 New Plugins Added

### Quality of Life Plugins (`lua/plugins/beginner-friendly.lua`)

#### 1. **Which-Key** - Command Discovery
- **What**: Shows available keybindings when you press Space
- **How to use**: Press `Space` and wait 1 second - see all available commands with descriptions
- **Why**: No more memorizing complex keybindings!

#### 2. **Auto-Save** - Never Lose Work
- **What**: Automatically saves your notes as you type
- **How to use**: Just type! Files save after 1 second of inactivity
- **Manual control**: `:ASToggle` to enable/disable
- **Why**: Focus on writing, not remembering to save

#### 3. **Undo Tree** - Visual Undo History
- **What**: See your edit history as a tree
- **How to use**: `Space + u` or `:UndotreeToggle`
- **Navigation**: `j/k` to move, `Enter` to go to that state
- **Why**: Easily recover any previous version of your text

#### 4. **Zen Mode** - Distraction-Free Writing
- **What**: Hides everything except your text
- **How to use**: `Space + z` or `:ZenMode`
- **Exit**: Press `Space + z` again or `:ZenMode`
- **Why**: Focus purely on writing without distractions

#### 5. **Twilight** - Dim Inactive Code
- **What**: Highlights current paragraph, dims the rest
- **How to use**: Automatically works with Zen Mode, or `:Twilight`
- **Why**: Helps focus on current section

#### 6. **Render Markdown** - Beautiful Markdown Display
- **What**: Shows markdown with proper formatting (headers, bold, lists)
- **How to use**: Automatic in `.md` files
- **Toggle**: Check settings if you want raw markdown view
- **Why**: Makes notes more readable and professional

#### 7. **Smooth Scrolling** - Better Navigation
- **What**: Smooth scrolling animations instead of jarring jumps
- **How to use**: Use `Ctrl+D`, `Ctrl+U`, or scroll wheel
- **Why**: More comfortable reading and navigation

---

## ⌨️ New Keybindings Added

### Essential Shortcuts (Works Everywhere)

| Shortcut | Action | Mode | Description |
|----------|--------|------|-------------|
| `jj` | Escape | Insert | Exit insert mode (easier than Esc) |
| `Ctrl+S` | Save | All | Save file (like every other editor) |
| `Ctrl+Q` | Quit | Normal | Quick quit |
| `Space + ?` | Help | Normal | Open quick reference guide |

### Window & Buffer Navigation

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl+H/J/K/L` | Move windows | Navigate between split windows |
| `Shift+H/L` | Switch buffers | Like browser tabs |
| `]b` / `[b` | Next/Previous buffer | Alternative buffer switching |

### Obsidian Note-Taking (`Space + o`)

| Shortcut | Command | Description |
|----------|---------|-------------|
| `Space + on` | New Note | Create a new note |
| `Space + oo` | Open Note | Open existing note |
| `Space + os` | Search Notes | Search across all notes |
| `Space + oq` | Quick Switch | Fast note switching |
| `Space + ot` | Today's Note | Open today's daily note |
| `Space + oy` | Yesterday's Note | Open yesterday's note |
| `Space + ob` | Backlinks | Show notes linking to current |
| `Space + ol` | Links | Show all links in current note |
| `Space + of` | Follow Link | Follow link under cursor |
| `Space + or` | Rename Note | Rename current note |
| `Space + ow` | Switch Workspace | Change workspace |

### Productivity Features

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Space + u` | Undo Tree | Visual undo history |
| `Space + z` | Zen Mode | Distraction-free writing |
| `Space + w` | Save | Alternative save command |
| `Space + x` | Save & Quit | Save and close file |

### Search & Navigation

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Space + sr` | Search/Replace | Start find and replace |
| `Space + ff` | Find Files | Search for files |
| `Space + fg` | Find Text | Search text in all files |
| `Space + fb` | Find Buffers | Search open buffers |
| `Space + fr` | Recent Files | Find recently opened files |
| `/text` | Search | Search for "text" in current file |
| `n` / `N` | Next/Prev | Next/previous search result (auto-centered) |

### View Controls

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Space + tn` | Toggle Numbers | Show/hide line numbers |
| `Space + tw` | Toggle Wrap | Enable/disable word wrap |

### Insert Mode Shortcuts

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl+H/J/K/L` | Move cursor | Navigate without leaving insert mode |
| `Ctrl+B/F` | Word navigation | Move by words in insert mode |
| `Ctrl+S` | Save & continue | Save and stay in insert mode |
| `Ctrl+Backspace` | Delete word | Delete word backwards |

---

## ⚙️ Configuration Improvements

### Enhanced Vim Options (`lua/plugins/astrocore.lua`)

#### Editor Behavior
- **Word wrap**: Enabled for comfortable note reading
- **Line breaking**: Smart word-boundary breaking
- **Spell checking**: Enabled for note-taking
- **Mouse support**: Full mouse support for beginners
- **Auto-indentation**: Smart indenting for structured notes
- **Persistent undo**: Never lose edit history

#### Search Improvements
- **Case-smart search**: Ignores case unless you use capitals
- **Incremental search**: Shows results as you type
- **Highlight search**: Highlights all matches

#### File Handling
- **No swap files**: Disabled (auto-save handles this)
- **No backup files**: Cleaner directory structure
- **System clipboard**: Copy/paste works with system clipboard

### Enhanced Obsidian Configuration (`lua/plugins/obsidian-nvim.lua`)

#### Daily Notes
- **Folder**: `daily/` for organization
- **Date format**: `YYYY-MM-DD` (sortable)
- **Templates**: Support for note templates

#### Note Creation
- **Timestamp IDs**: Automatic unique note IDs
- **Frontmatter**: Automatic metadata generation
- **Link handling**: Better link following and creation

#### Integration
- **Telescope finder**: Better search interface
- **URL handling**: Opens external links in browser
- **Completion**: Note and link completion in insert mode

---

## 🎨 Visual Enhancements

### Welcome Dashboard (`lua/plugins/dashboard.lua`)
- **Custom welcome screen**: Shows when you open Neovim
- **Quick actions**: One-key access to common tasks
- **Performance stats**: Shows startup time and plugin count
- **Helpful tips**: Reminds you of key shortcuts

### UI Improvements
- **Concealed markdown**: Hides syntax for cleaner view
- **Current line highlight**: Easy to see where you are
- **Better scrolling**: Keeps context visible around cursor
- **Improved completion**: Better popup menu size and behavior

---

## 📖 How to Use This Setup

### For Complete Beginners

1. **Starting Out**:
   ```
   nvim                    # Open Neovim
   i                       # Start typing
   jj                      # Exit insert mode
   Ctrl+S                  # Save
   ```

2. **Creating Notes**:
   ```
   Space + on              # New note
   Type your content
   Ctrl+S                  # Save (or wait for auto-save)
   ```

3. **Finding Notes**:
   ```
   Space + oq              # Quick switch between notes
   Space + os              # Search all notes
   Space + ff              # Find files
   ```

### For Getting Help

1. **Instant Help**:
   ```
   Space                   # Shows all available commands
   Space + ?               # Opens complete reference guide
   ```

2. **Emergency Commands**:
   ```
   :q!                     # Quit without saving
   u                       # Undo last change
   Ctrl+R                  # Redo
   ```

### Daily Workflow Example

```bash
# Open Neovim
nvim

# From dashboard, press 't' for today's note, or:
Space + ot               # Today's daily note

# Start writing
i                        # Insert mode
Type your thoughts...
jj                       # Back to normal mode

# Need to find something?
Space + os               # Search notes
Space + oq               # Quick switch

# Want focus mode?
Space + z                # Zen mode

# Need to see edit history?
Space + u                # Undo tree
```

---

## 🆘 Troubleshooting

### Common Issues

1. **"I'm stuck and don't know what mode I'm in"**
   - Press `Esc` or `jj` repeatedly until you're in normal mode
   - Look at the bottom-left corner for mode indicator

2. **"I can't save my file"**
   - Try `Ctrl+S` or `:w` or `Space + w`
   - Check if auto-save is working (should save automatically)

3. **"I accidentally changed something"**
   - Press `u` to undo
   - Use `Space + u` for visual undo tree

4. **"I want to see all shortcuts"**
   - Press `Space` and wait - WhichKey shows everything
   - Press `Space + ?` for the complete guide

### Getting More Help

- `:help` - Vim's built-in help
- `:checkhealth` - Check if everything is working
- `Space + ?` - Your quick reference guide

---

## 🔄 What Changed From Before

### Before
- Complex key combinations
- No auto-save
- Basic Obsidian integration
- Steep learning curve
- Easy to get lost

### After
- Simple, discoverable shortcuts
- Automatic saving
- Rich note-taking features
- Gentle learning curve
- Visual helpers everywhere

This setup lets you **focus on your notes** instead of fighting the editor!