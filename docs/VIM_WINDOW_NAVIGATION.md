# Vim Window Navigation — Quick Reference

> Context: VSCode Neovim extension. `<C-w>` is now forwarded to Neovim via `keybindings.json`.
> Prefix every command below with `<C-w>` while in **Normal mode**.

---

## Navigating Between Splits

| Keys         | Action                          |
|--------------|---------------------------------|
| `<C-w> h`    | Move focus → left split         |
| `<C-w> j`    | Move focus → split below        |
| `<C-w> k`    | Move focus → split above        |
| `<C-w> l`    | Move focus → right split        |
| `<C-w> w`    | Cycle to next split             |
| `<C-w> p`    | Jump to previous (last) split   |

> You also have `<C-h/j/k/l>` mapped in `vscode.lua` which does the same via VSCodeNotify —
> use whichever feels natural.

---

## Opening Splits

| Keys         | Action                          |
|--------------|---------------------------------|
| `<C-w> v`    | Vertical split (side by side)   |
| `<C-w> s`    | Horizontal split (top/bottom)   |
| `<C-w> n`    | New empty horizontal split      |

---

## Closing Splits

| Keys         | Action                          |
|--------------|---------------------------------|
| `<C-w> c`    | Close current split             |
| `<C-w> o`    | Close all OTHER splits (only)   |

---

## Resizing Splits

| Keys         | Action                          |
|--------------|---------------------------------|
| `<C-w> =`    | Equalize all split sizes        |
| `<C-w> >`    | Increase width                  |
| `<C-w> <`    | Decrease width                  |
| `<C-w> +`    | Increase height                 |
| `<C-w> -`    | Decrease height                 |
| `5<C-w> >`   | Increase width by 5 (prefix N)  |

---

## Moving the Split Itself

| Keys         | Action                                      |
|--------------|---------------------------------------------|
| `<C-w> H`    | Move current window to far **left**         |
| `<C-w> J`    | Move current window to far **bottom**       |
| `<C-w> K`    | Move current window to far **top**          |
| `<C-w> L`    | Move current window to far **right**        |
| `<C-w> T`    | Move current window into its own **tab**    |

---

## VS Code Tab Navigation (your existing mappings)

These are already in `vscode.lua`:

| Keys             | Action                              |
|------------------|-------------------------------------|
| `<leader>fb`     | Show all open editors (picker)      |
| `<leader>ff`     | Quick Open file (Ctrl+P equivalent) |
| `<C-h/j/k/l>`   | Navigate between editor groups      |

---

## Mental Model

```
<C-w> + direction letter  →  move FOCUS
<C-w> + CAPITAL letter    →  move the WINDOW itself
<C-w> + punctuation       →  resize or equalize
```

Splits you open with `<C-w>v` or `<C-w>s` become VS Code editor groups —
they behave identically to splits you open with the VS Code UI.
