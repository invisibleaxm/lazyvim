# 🤖 GitHub Copilot Quick Reference

**Complete guide to using Copilot inline suggestions and completion menu.**

---

## 🎯 Completion Suggestions

Copilot is integrated into Blink's completion menu in standalone Neovim. Use the same deliberate menu workflow as VS Code:

### Accept Suggestions

| Keymap      | Action                     | When to Use                                 |
| ----------- | -------------------------- | ------------------------------------------- |
| `<Tab>`     | Accept selected completion | **Most common** - accepts the selected item |
| `<C-j>`     | Select next completion     | Navigate forward                            |
| `<C-k>`     | Select previous completion | Navigate backward                           |
| `<C-Right>` | Accept next word only      | **Partial accept** - word by word           |
| `<C-l>`     | Accept line only           | Accept just current line                    |

💡 **Tip:** Use `<C-Right>` when you want only part of the suggestion!

### Navigate Suggestions

Use `<C-j>` / `<C-k>` to move through the completion menu. `<S-Tab>` also moves backward, and `<CR>` inserts a newline without accepting the selected item.

### Example Workflow

```powershell
# You type:
$tomorrow

# Copilot suggests (in gray):
$tomorrowDate = (Get-Date).AddDays(1).ToString("yyyy-MM-dd")

# Options:
# 1. Press <C-j>/<C-k> → Navigate completion items
# 2. Press <Tab> → Accept the selected item ✓
# 3. Press <C-Right> → Accept just "$tomorrowDate" when supported
# 4. Press <CR> → Insert a newline without accepting
```

---

## 📋 Completion Menu (Blink)

Copilot suggestions also appear in the completion dropdown menu with `` icon.

### Menu Navigation

| Keymap      | Action                           |
| ----------- | -------------------------------- |
| `<C-j>`     | Next item in menu                |
| `<C-k>`     | Previous item in menu            |
| `<Tab>`     | Accept selected item             |
| `<S-Tab>`   | Previous item in menu            |
| `<CR>`      | Insert newline without accepting |
| `<C-Space>` | Trigger menu manually            |
| `<C-e>`     | Close menu                       |

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

**Issue:** Tab cycles through completion menu instead of accepting Copilot.

**Reason:** Completion menu takes priority.

**Fix:**

- Use `<C-j>` to explicitly accept Copilot (bypasses menu)
- Or press `<C-e>` to close menu first, then `<Tab>`

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
- Accept with `<Tab>`, `<C-j>`, or `<C-Right>`
- Navigate with `<Alt-]>` / `<Alt-[>`

**Completion Menu (nvim-cmp):**

- Appears as **popup menu** with multiple items
- Shows suggestions from **all sources** (LSP, Copilot, snippets, buffer)
- Navigate with `<Tab>` / `<S-Tab>`
- Copilot items have `` icon

💡 **Both can show at the same time!** Menu shows multiple sources, ghost text shows one AI suggestion.

---

## 🎓 Learning Path

**Day 1:** Just use `<Tab>` to accept suggestions
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
