# 🎯 VSCode Integration - Hybrid Mode

**Successfully configured for Hybrid Mode!**

---

## 🎨 What is Hybrid Mode?

**Hybrid Mode** gives you the best of both worlds:
- ✅ **Neovim's powerful editing** (motions, text objects, visual mode, macros)
- ✅ **VSCode's IntelliSense & Copilot** (familiar completion, reliable LSP)
- ✅ **All VSCode features** (debugging, extensions, UI)
- ✅ **No conflicts** between Neovim and VSCode features

---

## ⚙️ How It Works

### When Running in VSCode:

**Enabled (Neovim):**
- ✅ Vim motions (`hjkl`, `w`, `b`, `ciw`, etc.)
- ✅ Visual mode (`v`, `V`, `Ctrl+v`)
- ✅ Text objects (`ci"`, `da{`, `yap`, etc.)
- ✅ Registers and macros (`"ay`, `qa...q`, `@a`)
- ✅ Vim commands (`:w`, `:q`, `:s///`, etc.)
- ✅ Your LazyVim keybindings from `vscode.lua`

**Disabled (Using VSCode Instead):**
- ❌ nvim-cmp (VSCode IntelliSense instead)
- ❌ Neovim Copilot (VSCode Copilot instead)
- ❌ Neovim LSP servers (VSCode language servers instead)
- ❌ Telescope (VSCode `Ctrl+P` instead)
- ❌ Neo-tree (VSCode Explorer instead)
- ❌ ToggleTerm (VSCode integrated terminal instead)
- ❌ Trouble (VSCode Problems panel instead)
- ❌ Noice/Notify (VSCode notifications instead)

### When Running Standalone Neovim:

**Everything works as before!** All plugins, LSP, completion, Copilot - fully functional.

---

## 🚀 Usage

### Enable/Disable Neovim Mode in VSCode

**Toggle Neovim:**
- Press `Ctrl+Alt+N` (default VSCode Neovim extension keybinding)
- Or use Command Palette: `Toggle Neovim Mode`

**Status:**
- Bottom status bar shows "Normal", "Insert", "Visual" when Neovim is active
- When inactive, VSCode works normally

### Recommended Workflow

1. **Open VSCode**
2. **Enable Neovim mode** (`Ctrl+Alt+N`)
3. **Edit with Vim motions**, complete with VSCode IntelliSense
4. **Toggle off** if you need pure VSCode experience

---

## ⌨️ Keybindings

### Your Existing Keybindings Work!

All your VSCode keybindings from `keybindings.json` continue to work:

| Key | Action | Context |
|-----|--------|---------|
| `Ctrl+E` | Open Explorer | Always |
| `Ctrl+J` | IntelliSense next | When suggesting |
| `Ctrl+K` | IntelliSense previous | When suggesting |
| `Tab` | Accept suggestion | When suggesting |
| `Ctrl+\` | Toggle terminal | Always |
| `j`/`k` | Navigate explorer | In file explorer |
| `r` | Rename file | In file explorer |

### Vim Keybindings (When Neovim Active)

| Key | Mode | Action |
|-----|------|--------|
| `hjkl` | Normal | Navigate |
| `w`/`b`/`e` | Normal | Word navigation |
| `i`/`a`/`o` | Normal | Enter insert mode |
| `v`/`V`/`Ctrl+v` | Normal | Visual mode |
| `d`/`y`/`c` | Normal/Visual | Delete/yank/change |
| `ciw` | Normal | Change word |
| `:w` | Command | Save file |
| `:q` | Command | Close editor |

### LazyVim Keybindings in VSCode

Your `vscode.lua` is configured with these leader key commands:

| Key | Action |
|-----|--------|
| `<leader>ff` | Quick Open (VSCode `Ctrl+P`) |
| `<leader>fg` | Find in Files |
| `<leader>fb` | Show All Editors |
| `<leader>ca` | Code Actions |
| `gd` | Go to Definition |
| `gr` | Go to References |
| `K` | Show Hover |
| `gcc` | Toggle Comment |

💡 **Leader key is `Space`** - same as standalone Neovim!

---

## 🐛 Troubleshooting

### Neovim Commands Don't Work in VSCode

**Check:**
1. Is Neovim mode enabled? (Look for status in bottom bar)
2. Press `Ctrl+Alt+N` to toggle

### IntelliSense Not Showing

**This is normal in hybrid mode!** Neovim doesn't show VSCode IntelliSense unless you type.

**Trigger manually:**
- Press `Ctrl+Space` (VSCode default)

### Completions Appear Twice

**This shouldn't happen in hybrid mode.** If it does:
1. Reload VSCode: `Ctrl+Shift+P` → "Reload Window"
2. Check that plugins disabled correctly

### Copilot Not Working

**Use VSCode Copilot:**
- It shows as gray text (same as normal VSCode)
- Press `Tab` to accept
- Or `Alt+]` / `Alt+[` to cycle suggestions

**Neovim Copilot is disabled** in VSCode mode (uses VSCode's instead).

### Keybindings Conflict

**Your keybindings are already configured correctly!**

If you notice conflicts:
1. Check `keybindings.json` for the specific key
2. Add `when: !neovim.mode` to disable in Neovim mode
3. Or add `when: neovim.mode` to enable only in Neovim mode

---

## 🔧 Configuration Files

### Modified Files

**Neovim plugins disabled in VSCode:**
- `lua/plugins/completion.lua` - nvim-cmp disabled
- `lua/plugins/copilot.lua` - Neovim Copilot disabled
- `lua/plugins/lsp.lua` - LSP servers disabled
- `lua/plugins/telescope.lua` - Telescope disabled
- `lua/plugins/powershell.lua` - PowerShell LSP disabled
- `lua/plugins/trouble.lua` - Trouble disabled
- `lua/plugins/neotree.lua` - Neo-tree disabled
- `lua/plugins/toggleterm.lua` - ToggleTerm disabled
- `lua/plugins/notifications.lua` - Notifications disabled

**VSCode settings updated:**
- Added `vscode-neovim.useCtrlKeysForNormalMode: false`
- Added `vscode-neovim.useCtrlKeysForInsertMode: false`
- Enabled VSCode quick suggestions
- Enabled commit character suggestions

**What's kept:**
- `lua/plugins/vscode.lua` - VSCode-specific keymaps
- Your existing keybindings in `keybindings.json`
- All VSCode settings and extensions

---

## 💡 Best Practices

### When to Use Neovim Mode

**Great for:**
- ✅ Editing code with complex refactoring (motions, macros)
- ✅ Working with PowerShell scripts (your optimized workflow)
- ✅ Large text manipulations (visual mode, block edits)
- ✅ When you want consistent Vim muscle memory

### When to Disable Neovim Mode

**Great for:**
- ✅ Using VSCode-specific UI features (debugging panels, extensions)
- ✅ When pairing with someone unfamiliar with Vim
- ✅ Complex debugging sessions
- ✅ Working with VSCode-only extensions

### Toggle Freely!

You can **toggle Neovim mode on/off** anytime without losing work:
- `Ctrl+Alt+N` to switch
- No restart needed
- Files stay open
- Undo history preserved

---

## 📚 Related Documentation

- **[Complete User Guide](NEOVIM_USER_GUIDE.md)** - Full Neovim features guide
- **[PowerShell Development](POWERSHELL_DEVELOPMENT.md)** - PowerShell workflow
- **[Copilot Quick Reference](COPILOT_QUICKREF.md)** - Copilot usage
- **VSCode Neovim Extension:** https://github.com/vscode-neovim/vscode-neovim

---

## ✅ Testing Your Setup

### Quick Test Checklist

**In VSCode with Neovim mode enabled:**

1. ✅ Press `hjkl` - should navigate
2. ✅ Press `i` - should enter insert mode (see "Insert" in status bar)
3. ✅ Type some code - should show VSCode IntelliSense
4. ✅ Press `Ctrl+J` - should cycle through suggestions
5. ✅ Press `Tab` - should accept suggestion
6. ✅ Press `Esc` - should return to normal mode
7. ✅ Type `ciw` - should change word
8. ✅ Press `<Space>ff` - should open Quick Open
9. ✅ Type `:w` - should save file
10. ✅ Press `Ctrl+Alt+N` - should toggle Neovim off

**All working? You're ready! 🎉**

---

## 🎓 Learning Resources

**VSCode Neovim:**
- Official docs: https://github.com/vscode-neovim/vscode-neovim
- Settings reference: https://github.com/vscode-neovim/vscode-neovim#settings

**Vim in VSCode:**
- Vim basics: https://vim.fandom.com/wiki/Tutorial
- VSCode tips: https://code.visualstudio.com/docs/editor/editingevolved

**Your Config:**
- Standalone Neovim: Launch `nvim` in terminal
- All features: See [NEOVIM_USER_GUIDE.md](NEOVIM_USER_GUIDE.md)

---

**Enjoy your hybrid Vim+VSCode experience! 🚀**
