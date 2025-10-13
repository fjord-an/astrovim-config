# HTML & Markdown Preview Setup

**Last Updated**: October 13, 2025  
**System**: macOS (M3 MacBook Pro, 36GB RAM)

## Overview

This Neovim configuration includes multiple preview methods for Markdown and HTML files, providing flexibility for different use cases—from quick documentation checks to full web development workflows.

---

## Installed Preview Methods

### 1. In-Editor Rendering

#### render-markdown.nvim (Markdown Only)
- **Type**: Instant in-buffer rendering
- **Use Case**: Quick markdown editing with live formatting
- **Features**: Headers, bold, italic, code blocks render beautifully
- **Performance**: Instant, no external process
- **Status**: ✅ Already active (from beginner-friendly.lua)

####  w3m.vim (HTML Only)
- **Type**: Text-based browser in split/tab
- **Use Case**: Quick HTML structure preview for documentation
- **Features**: Tables, lists, basic HTML rendering
- **Performance**: Lightweight (~5MB RAM)
- **Limitations**: No CSS, No JavaScript
- **Commands**: `:W3m`, `:W3mSplit`, `:W3mVSplit`, `:W3mTab`
- **Keybindings**: 
  - `<leader>mw` - Open w3m in split
  - `<leader>mh` - Open w3m in current window

---

### 2. Browser Preview (peek.nvim)

**Best for**: Markdown AND HTML with live refresh

- **Type**: Auto-refreshing browser preview
- **Use Case**: Universal preview for both MD and HTML
- **Browser**: Floorp (Firefox fork)
- **Features**: 
  - Live updates on save
  - Syntax highlighting
  - Dark theme
  - Full CSS/JS support for HTML
  - Markdown rendering with GitHub flavor
- **Performance**: ~50-100MB when active, lazy-loaded
- **Commands**: `:PeekOpen`, `:PeekClose`
- **Keybindings**:
  - `<leader>mp` - Open peek preview
  - `<leader>mc` - Close peek preview

---

### 3. Development Server (live-server)

**Best for**: Full web development with assets

- **Type**: HTTP server with live reload
- **Use Case**: Complex HTML/CSS/JS projects with multiple files
- **Browser**: Floorp
- **Features**:
  - Full HTTP server on port 8080
  - Serves entire directory (not just single file)
  - Auto-refreshes on any file change
  - Supports relative paths, images, CSS, JS
- **Performance**: ~30-50MB Node process
- **Commands**: `:LiveServerStart`, `:LiveServerStop`, `:LiveServerToggle`
- **Keybindings**:
  - `<leader>ml` - Start live server
  - `<leader>ms` - Stop live server
  - `<leader>mt` - Toggle live server

---

### 4. Terminal Markdown Viewer (glow)

**Best for**: Quick markdown checks in terminal

- **Type**: Terminal-based markdown renderer
- **Use Case**: Fast markdown preview in floating window
- **Features**: Beautiful terminal rendering, no external browser
- **Performance**: Instant, ~10MB
- **Command**: `:Glow`
- **Keybinding**: `<leader>mg`
- **Status**: ✅ Already installed and configured

---

## Complete Keybindings Reference

| Keybinding | Command | Tool | Description |
|------------|---------|------|-------------|
| `<leader>mp` | `:PeekOpen` | peek.nvim | Open browser preview (MD/HTML) |
| `<leader>mc` | `:PeekClose` | peek.nvim | Close browser preview |
| `<leader>mw` | `:W3mSplit` | w3m.vim | Open w3m in split (HTML only) |
| `<leader>mh` | `:W3m` | w3m.vim | Open w3m in current window |
| `<leader>mg` | `:Glow` | glow.nvim | Open Glow terminal viewer (MD only) |
| `<leader>ml` | `:LiveServerStart` | live-server | Start development server |
| `<leader>ms` | `:LiveServerStop` | live-server | Stop development server |
| `<leader>mt` | `:LiveServerToggle` | live-server | Toggle development server |

**Note**: `<leader>` is the space key by default in AstroNvim.

---

## Workflow Recommendations

### Quick Documentation HTML Tables
```
1. Open HTML file: `nvim myfile.html`
2. Press: <leader>mw
3. HTML renders in split window with w3m
```

### Markdown Note-Taking
```
1. render-markdown.nvim works automatically (already active)
2. For terminal preview: <leader>mg (Glow)
3. For browser preview: <leader>mp (peek.nvim)
```

### Web Development (HTML + CSS + JS)
```
1. Open your HTML file: `nvim index.html`
2. Start server: <leader>ml
3. Floorp opens to http://localhost:8080
4. Edit and save - browser auto-refreshes
5. Stop server when done: <leader>ms
```

### Mixed Workflow
```
- Use render-markdown.nvim for inline MD editing
- Use peek.nvim (<leader>mp) for quick HTML checks
- Use live-server (<leader>ml) for active web development
- Use w3m (<leader>mw) for super-fast HTML structure checks
```

---

## Dependencies

| Tool | Path | Purpose | Status |
|------|------|---------|--------|
| Deno | `/opt/homebrew/bin/deno` | Build peek.nvim | ✅ Installed |
| w3m | `/opt/homebrew/bin/w3m` | In-editor HTML viewer | ✅ Installed |
| live-server | `/opt/homebrew/bin/live-server` | Development server | ✅ Installed |
| Node.js | `/opt/homebrew/bin/node` | Run live-server | ✅ Already had |
| Floorp | `/Applications/Floorp.app` | Browser for previews | ✅ Already had |
| Glow | `/opt/homebrew/bin/glow` | Markdown terminal viewer | ✅ Already had |

---

## Troubleshooting

### peek.nvim fails to open browser

**Symptom**: `:PeekOpen` runs but no browser appears

**Solutions**:
```bash
# 1. Verify Deno is installed
which deno

# 2. Rebuild peek.nvim
cd ~/.local/share/nvim/lazy/peek.nvim
deno task --quiet build:fast

# 3. Check Floorp path
ls -la /Applications/Floorp.app

# 4. Test browser manually
open -a "Floorp" http://example.com

# 5. Check peek.nvim logs
:messages  # in Neovim
```

---

### w3m command not found

**Symptom**: `:W3mSplit` says "w3m not found"

**Solutions**:
```bash
# Install w3m
brew install w3m

# Verify installation
which w3m

# Restart Neovim
```

---

### live-server command not found

**Symptom**: `:LiveServerStart` fails with error

**Solutions**:
```bash
# Install live-server globally
npm install -g live-server

# Check npm global path is in $PATH
echo $PATH | grep npm

# If not in PATH, add to ~/.zshrc:
echo 'export PATH="$PATH:$(npm config get prefix)/bin"' >> ~/.zshrc
source ~/.zshrc

# Verify installation
which live-server
```

---

### Browser doesn't open automatically

**Symptom**: Server starts but browser doesn't open

**Solutions**:
```bash
# 1. Test Floorp launch manually
open -a "Floorp" http://localhost:8080

# 2. If Floorp name is wrong, check actual name
ls -la /Applications/ | grep -i floorp

# 3. Update browser name in config if needed
# Edit: ~/.config/nvim/lua/plugins/user.lua (for peek.nvim)
# Edit: ~/.config/nvim/lua/plugins/html-preview.lua (for live-server)
```

---

### peek.nvim build failures

**Symptom**: Deno build fails during `:Lazy sync`

**Solutions**:
```bash
# 1. Check Deno version (needs 1.20+)
deno --version

# 2. Update Deno if needed
brew upgrade deno

# 3. Clear Deno cache and rebuild
cd ~/.local/share/nvim/lazy/peek.nvim
rm -rf ~/.cache/deno
deno task build:fast

# 4. Check internet connection (Deno downloads dependencies)
```

---

### HTML Preview Performance Issues

**Symptom**: Neovim slows down when using preview

**Solutions**:

1. **For large HTML files**: Use w3m instead of peek.nvim
2. **For complex sites**: Use live-server only when actively developing
3. **Memory usage**: Check with `:Lazy profile` in Neovim
4. **Stop unused servers**: `:LiveServerStop` when done
5. **Close peek**: `:PeekClose` when not needed

---

## Performance Notes

### Lazy Loading Strategy

All preview plugins are lazy-loaded to minimize impact on Neovim startup:

- **render-markdown.nvim**: Loads on markdown filetype only
- **peek.nvim**: Loads when `:PeekOpen` called or markdown/html opened
- **w3m.vim**: Loads when `:W3m` commands called or HTML opened
- **live-server**: Commands available immediately (lightweight)
- **glow.nvim**: Loads when `:Glow` called

### Startup Time Impact

```bash
# Check your startup time
nvim --startuptime startup.log test.md
grep "TOTAL" startup.log
```

**Expected impact**: <50ms additional startup time with all plugins

### RAM Usage (M3 MacBook Pro 36GB)

- **Idle Neovim**: ~100MB
- **+ render-markdown**: +5MB
- **+ peek.nvim active**: +50-100MB
- **+ w3m split**: +10MB
- **+ live-server**: +30-50MB

**Total worst case**: ~300MB (still very reasonable on 36GB system)

---

## Configuration Files

### Main Files
- `~/.config/nvim/lua/plugins/user.lua` - peek.nvim & glow.nvim config
- `~/.config/nvim/lua/plugins/html-preview.lua` - w3m & live-server config
- `~/.config/nvim/lua/plugins/astrocore.lua` - Keybindings
- `~/.config/nvim/lua/plugins/beginner-friendly.lua` - render-markdown.nvim

### Quick Reference
```bash
# Edit peek.nvim config
nvim ~/.config/nvim/lua/plugins/user.lua

# Edit w3m/live-server config
nvim ~/.config/nvim/lua/plugins/html-preview.lua

# Edit keybindings
nvim ~/.config/nvim/lua/plugins/astrocore.lua

# View this guide
nvim ~/.config/nvim/PREVIEW_SETUP.md
```

---

## Advanced Usage

### Customizing peek.nvim Browser

Edit `~/.config/nvim/lua/plugins/user.lua`:

```lua
app = 'open -a "Floorp"',  -- Change to your preferred browser
-- Examples:
-- app = 'open -a "Google Chrome"',
-- app = 'open -a "Firefox"',
-- app = 'open -a "Safari"',
```

### Customizing live-server Port

Edit `~/.config/nvim/lua/plugins/html-preview.lua`:

```lua
{ "live-server", dir, "--port=8080", "--no-browser" },
-- Change 8080 to your preferred port
```

### Customizing w3m Split Size

When calling w3m manually:
```vim
:vertical 50W3mSplit  " 50% width vertical split
:horizontal 20W3mSplit  " 20 lines horizontal split
```

---

## Future Enhancements

Potential additions (not yet implemented):

1. **Markdown PDF Export**: Using `pandoc` or `weasyprint`
2. **HTML Linting**: Integrate `htmlhint` or `tidy`
3. **CSS Preview**: Hot-reload CSS without full page refresh
4. **Multiple Browser Support**: Quick switch between browsers
5. **Preview on External Monitor**: Configurable display target

---

## Support & Resources

### Official Plugin Documentation
- peek.nvim: https://github.com/toppair/peek.nvim
- render-markdown.nvim: https://github.com/MeanderingProgrammer/render-markdown.nvim
- glow.nvim: https://github.com/ellisonleao/glow.nvim
- w3m.vim: https://github.com/yuratomo/w3m.vim

### Tool Documentation
- live-server: https://www.npmjs.com/package/live-server
- w3m: http://w3m.sourceforge.net/
- Deno: https://deno.land/

### AstroNvim Resources
- AstroNvim Docs: https://docs.astronvim.com/
- Plugin Configuration: https://docs.astronvim.com/configuration/plugins/

---

## Changelog

### 2025-10-13 - Initial Setup
- Installed Deno, w3m, live-server
- Enabled peek.nvim with Floorp browser support
- Created html-preview.lua with w3m and live-server
- Added keybindings to astrocore.lua
- Documented complete setup

---

**Enjoy your seamless Markdown and HTML preview experience! 🚀**
