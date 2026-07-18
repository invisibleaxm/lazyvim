# Clipboard & Mouse Integration Guide

This guide explains how clipboard and mouse integration works across different platforms and over SSH.

## 🖱️ Mouse Support

**Enabled globally** in [lua/config/options.lua](../lua/config/options.lua):
```lua
vim.opt.mouse = "a"  -- Enable mouse in all modes
```

### What Works

✅ **Click to position cursor** - Works everywhere (terminal, SSH, VSCode)
✅ **Drag to select text** - Visual selection in all environments
✅ **Scroll wheel** - Scroll through files
✅ **Right-click** - Context menu (terminal-dependent)

### Right-Click Copy Behavior

The right-click behavior depends on your terminal:

| Terminal | Right-Click Behavior |
|----------|---------------------|
| **WezTerm** | Copy to system clipboard (terminal handles it) |
| **Windows Terminal** | Copy to system clipboard (terminal handles it) |
| **iTerm2** | Copy to system clipboard (terminal handles it) |
| **Alacritty** | Copy to system clipboard (terminal handles it) |
| **Kitty** | Copy to system clipboard (terminal handles it) |

The terminal intercepts the right-click and copies the selected text to your OS clipboard. Neovim doesn't need to handle this!

## 📋 Clipboard Integration

### Local Usage (Not SSH)

**Automatic system clipboard integration** via:
```lua
vim.opt.clipboard = "unnamedplus"
```

This means:
- `y` (yank) → Copies to **both** Neovim register AND system clipboard
- `p` (paste) → Pastes from Neovim register (which mirrors system clipboard)
- `"+y` → Explicitly yank to system clipboard
- `"+p` → Explicitly paste from system clipboard

**Visual mode mouse selection**:
1. Mouse-select text (enters visual mode)
2. Right-click to copy (terminal copies to OS clipboard)
3. Use middle-click or `Ctrl+V` / `Cmd+V` in other apps to paste

### Over SSH (Remote Server)

When SSH'd into a remote server, we use **OSC 52** escape sequences to sync clipboard with your local machine.

**Auto-detection** in [lua/config/options.lua](../lua/config/options.lua):
```lua
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste_function,
      ["*"] = paste_function,
    },
  }
end
```

**How it works**:
1. You SSH into remote server
2. Neovim detects `SSH_TTY` environment variable
3. When you yank (`y`), Neovim sends OSC 52 escape sequence
4. Your **local terminal** intercepts the sequence
5. Terminal copies text to your **local OS clipboard**
6. You can paste on your local machine with `Ctrl+V` / `Cmd+V`

### Terminal Requirements for OSC 52

Your terminal must support OSC 52 escape sequences:

| Terminal | OSC 52 Support | Configuration |
|----------|----------------|---------------|
| **WezTerm** | ✅ Built-in | Enabled by default |
| **iTerm2** | ✅ Built-in | Enable in Prefs → General → Applications may access clipboard |
| **Alacritty** | ✅ Built-in | Enable `osc52` in config |
| **Windows Terminal** | ✅ Built-in | Enabled by default (recent versions) |
| **Kitty** | ✅ Built-in | Enabled by default |
| **tmux** | ⚠️ Requires config | See below |

### tmux + OSC 52 Configuration

If you use tmux, add to your `~/.tmux.conf`:

```bash
# Enable OSC 52 clipboard support (for SSH)
set -g set-clipboard on
set -ag terminal-overrides "vte*:XT:Ms=\\E]52;c;%p2%s\\7,xterm*:XT:Ms=\\E]52;c;%p2%s\\7"
```

Then reload: `tmux source-file ~/.tmux.conf`

## 🎯 Recommended Keybindings

All configured in [lua/config/keymaps.lua](../lua/config/keymaps.lua):

| Keymap | Mode | Action | Description |
|--------|------|--------|-------------|
| `<leader>y` | Normal/Visual | `"+y` | Yank to system clipboard |
| `<leader>Y` | Normal | `"+Y` | Yank line to system clipboard |
| `<leader>p` | Visual | `"_dP` | Paste without yanking (preserve register) |
| `<leader>d` | Normal/Visual | `"_d` | Delete without yanking (black hole) |
| `y` | Normal/Visual | yank | Auto-copies to clipboard (`clipboard=unnamedplus`) |

**With `clipboard=unnamedplus`**:
- Regular `y` already copies to system clipboard
- Use `<leader>y` when you want to be explicit
- Use `<leader>p` in visual mode to paste without overwriting register

## 🧪 Testing

### Local Clipboard (Not SSH)

```vim
" Test 1: Yank and paste in external app
yy          " Yank current line
" Paste in external app with Ctrl+V / Cmd+V

" Test 2: Copy from external app and paste in Neovim
" Copy text from browser/editor
p           " Paste in Neovim
```

### SSH Clipboard (OSC 52)

```bash
# SSH into remote server
ssh user@remote-server

# In Neovim on remote
:echo $SSH_TTY           # Should show TTY device
:lua print(vim.env.SSH_TTY)  # Should not be nil

# Test yanking
yy                        # Yank current line
# OSC 52 sequence sent to terminal
# Paste on LOCAL machine with Ctrl+V / Cmd+V
```

### Mouse Selection

```vim
" Test 1: Click and drag to select
" - Click anywhere to position cursor
" - Click and drag to visual-select text
" - Right-click to copy to OS clipboard (terminal handles)
" - Paste outside Neovim with Ctrl+V / Cmd+V

" Test 2: Middle-click paste (Unix)
" - Select text with mouse
" - Middle-click to paste in Neovim
```

## 🐛 Troubleshooting

### Issue: Clipboard not working locally

**Check:**
```vim
:echo has('clipboard')  " Should return 1
:set clipboard?         " Should show 'unnamedplus'
```

**Fix:** Install clipboard provider
- **Windows**: Should work out of box
- **macOS**: Should work out of box
- **Linux**: Install `xclip` or `xsel`
  ```bash
  # Ubuntu/Debian
  sudo apt install xclip

  # Arch
  sudo pacman -S xclip

  # Fedora
  sudo dnf install xclip
  ```

### Issue: OSC 52 not working over SSH

**Check:**
```vim
:lua print(vim.env.SSH_TTY)       " Should show TTY device
:lua print(vim.g.clipboard.name)  " Should show 'OSC 52'
```

**Fix:**
1. Update your terminal to latest version
2. For tmux, add OSC 52 config (see above)
3. Test terminal OSC 52 support:
   ```bash
   printf "\033]52;c;$(printf "test" | base64)\a"
   # Should copy "test" to clipboard
   ```

### Issue: Right-click doesn't copy

**This is handled by your terminal, not Neovim.**

**Enable in terminal settings:**
- **WezTerm**: Already enabled
- **Windows Terminal**: Settings → Profiles → Advanced → "Copy on select"
- **iTerm2**: Preferences → General → Selection → "Copy to clipboard on selection"
- **Alacritty**: Add to `alacritty.yml`:
  ```yaml
  selection:
    save_to_clipboard: true
  ```

### Issue: Mouse not working

**Check:**
```vim
:set mouse?  " Should show 'a'
```

**Fix:**
```vim
:set mouse=a  " Enable in all modes
```

## 📚 Resources

- [Neovim Clipboard Documentation](https://neovim.io/doc/user/provider.html#clipboard)
- [OSC 52 Specification](https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Operating-System-Commands)
- [tmux Clipboard Integration](https://github.com/tmux/tmux/wiki/Clipboard)

## 🎬 Quick Reference

**Local machine (not SSH)**:
- Mouse select + right-click → Copies to OS clipboard
- `y` in Neovim → Copies to OS clipboard
- `p` in Neovim → Pastes from OS clipboard

**Over SSH**:
- Mouse select + right-click → Copies to **local** OS clipboard (via OSC 52)
- `y` in Neovim → Copies to **local** OS clipboard (via OSC 52)
- `p` in Neovim → Pastes from register
- **You can paste yanked text on your local machine!**

**Best Practice**:
- Use mouse to select and terminal's right-click to copy
- Use `y`/`p` for Neovim-internal copying
- Use `<leader>y` when you specifically want system clipboard
- Use `<leader>p` in visual mode to preserve register
