# 🤖 GitHub Copilot Quick Reference

**Complete guide to using Copilot inline suggestions and completion menu.**

---

## 🎯 Completion Suggestions

Copilot is integrated into Blink's completion menu in standalone Neovim. Use the same deliberate menu workflow as VS Code:

### Accept Suggestions

Same chords in standalone Neovim and VS Code IntelliSense.

| Keymap      | Action                     | When to Use                                      |
| ----------- | -------------------------- | ------------------------------------------------ |
| `<Tab>`     | Next completion item       | Cycle the menu (does not accept)                 |
| `<S-Tab>`   | Previous completion item   | Cycle backward                                   |
| `<C-j>`     | Next completion item       | Alias; **only while the menu is open**           |
| `<C-k>`     | Previous completion item   | Alias; **only while the menu is open**           |
| `<CR>`      | Accept selected item       | Menu open. Newline if the menu is closed         |
| `<C-Right>` | Accept next word only      | Partial accept when the source supports it       |
| `<Esc>`     | Dismiss menu               | Leaves insert mode in Neovim after dismiss       |

`Ctrl+J` / `Ctrl+K` are **not** bound in the terminal. A shell still uses `Ctrl+K` to kill to end-of-line.

### Example Workflow

```powershell
# You type:
$tomorrow

# Menu opens with the first item preselected (like VS Code)

# 1. Tab / Ctrl+J / Down  → next item
# 2. Shift+Tab / Ctrl+K / Up → previous item
# 3. Enter → accept the selected item
# 4. Esc → close the menu
```

---

## 📋 Completion Menu (Blink)

Copilot suggestions also appear in the completion dropdown menu with `` icon.

### Menu Navigation

| Keymap      | Action                           |
| ----------- | -------------------------------- |
| `<Tab>` / `<C-j>` / Down | Next item in menu                |
| `<S-Tab>` / `<C-k>` / Up | Previous item in menu            |
| `<CR>`                   | Accept selected item             |
| `<C-Space>`              | Trigger menu manually            |
| `<C-e>` / `<Esc>`        | Close menu                       |

### Source Priority (What Shows First)

1. **LSP** - Language server keywords (e.g., `function`, `param`)
2. **Copilot** - AI suggestions
3. **Snippets** - Code templates (`func`, `try`, etc.)
4. **Buffer** - Words from open files (4+ chars)
5. **Path** - File paths (3+ chars)

---

## 🎛️ Copilot Panel

Open a full panel of Copilot suggestions:

| Keymap        | Action                      |
| ------------- | --------------------------- |
| `<Alt-Enter>` | Open Copilot panel          |
| `]]`          | Jump to next suggestion     |
| `[[`          | Jump to previous suggestion |
| `<CR>`        | Accept selected suggestion  |
| `gr`          | Refresh suggestions         |
| `q`           | Close panel                 |

---

## 🔧 Copilot Commands

**In command mode (`:`):**

| Command            | Description                           |
| ------------------ | ------------------------------------- |
| `:Copilot auth`    | Authenticate with GitHub (first time) |
| `:Copilot status`  | Check Copilot status                  |
| `:Copilot enable`  | Enable Copilot                        |
| `:Copilot disable` | Disable Copilot                       |
| `:Copilot panel`   | Open suggestions panel                |

**Using leader key:**

| Keymap       | Description           |
| ------------ | --------------------- |
| `<leader>co` | Toggle Copilot on/off |

---

## 🚀 Best Practices

### When Ghost Text Appears

**✅ Do:**

- Use `<Tab>` or `<C-j>` if the suggestion is good
- Use `<C-Right>` to accept word-by-word if partially good
- Use `<Alt-]>` to cycle through alternatives
- Keep typing to ignore (it disappears automatically)

**❌ Don't:**

- Try to arrow-key through ghost text (it's not selectable)
- Get confused if it disappears (it reappears as you type)
- Press Escape (just keep typing to ignore)

### PowerShell Specific

**Copilot is great for:**

- Completing cmdlet parameters
- Generating common patterns (loops, error handling)
- Writing comment-based help
- Creating Pester test templates

**Example:** Type `function Get-` and Copilot suggests full function with params!

---

## 🐛 Troubleshooting

### Ghost Text Not Showing

```
:Copilot status
```

Check if authenticated and enabled.

**Fix:**

```
:Copilot auth
```

Follow authentication flow.

### Suggestions Not Relevant

Try:

1. Add more context (comments, variable names)
2. Press `<Alt-]>` for next suggestion
3. Type more to refine context

### Conflicts with Tab Key

**Issue:** Tab cycles the menu instead of accepting.

**Reason:** Tab is next-item, same as VS Code. Accept is Enter.

**Fix:**

- Press `<CR>` to accept the selected item
- Or press `<C-e>` to close the menu first

### Copilot Disabled

```
:Copilot enable
```

Or toggle with `<leader>co`.

---

## 📊 Completion vs Ghost Text

**Ghost Text (Inline Suggestions):**

- Appears as **gray text** after cursor
- Shows **one suggestion** at a time
- Accept with `<CR>` when the item is selected in the menu
- Word-wise accept with `<C-Right>` when ghost text is enabled
- Navigate with `<Alt-]>` / `<Alt-[>`

**Completion Menu (blink.cmp):**

- Appears as **popup menu** with multiple items
- Shows suggestions from **all sources** (LSP, Copilot, snippets, buffer)
- Navigate with `<Tab>` / `<S-Tab>` / `<C-j>` / `<C-k>`
- Accept with `<CR>`

💡 **Both can show at the same time!** Menu shows multiple sources, ghost text shows one AI suggestion.

---

## 🎓 Learning Path

**Day 1:** `Tab` to cycle, `Enter` to accept
**Day 2:** Try `<C-Right>` for word-by-word acceptance
**Day 3:** Use `<Alt-]>` to explore alternatives
**Week 2:** Open panel with `<Alt-Enter>` for complex completions

---

## 📚 Related Docs

- **[Complete User Guide](NEOVIM_USER_GUIDE.md)** - All features
- **[PowerShell Guide](POWERSHELL_DEVELOPMENT.md)** - PowerShell-specific features
- **[Completion Settings](../lua/plugins/completion.lua)** - Configuration details

---

**Happy coding with AI! 🤖✨**
