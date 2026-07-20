-- VSCode-specific configuration
if not vim.g.vscode then
  return {}
end

-- Keymaps that work well in VSCode
local keymap = vim.keymap.set

-- Better navigation
keymap("n", "<C-j>", ":call VSCodeNotify('workbench.action.navigateDown')<CR>")
keymap("n", "<C-k>", ":call VSCodeNotify('workbench.action.navigateUp')<CR>")
keymap("n", "<C-h>", ":call VSCodeNotify('workbench.action.navigateLeft')<CR>")
keymap("n", "<C-l>", ":call VSCodeNotify('workbench.action.navigateRight')<CR>")

-- File navigation
keymap("n", "<leader>ff", ":call VSCodeNotify('workbench.action.quickOpen')<CR>")
keymap("n", "<leader>fg", ":call VSCodeNotify('workbench.action.findInFiles')<CR>")
keymap("n", "<leader>fb", ":call VSCodeNotify('workbench.action.showAllEditors')<CR>")

-- Editor actions
keymap("n", "<leader>ca", ":call VSCodeNotify('editor.action.quickFix')<CR>")
keymap("n", "gr", ":call VSCodeNotify('editor.action.goToReferences')<CR>")
keymap("n", "gd", ":call VSCodeNotify('editor.action.revealDefinition')<CR>")
keymap("n", "gi", ":call VSCodeNotify('editor.action.goToImplementation')<CR>")
keymap("n", "K", ":call VSCodeNotify('editor.action.showHover')<CR>")

-- Comment toggling
keymap("n", "gcc", ":call VSCodeNotify('editor.action.commentLine')<CR>")
keymap("x", "gc", ":call VSCodeNotify('editor.action.commentLine')<CR>")

-- Center cursor on scroll
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Change entire word under cursor (regardless of cursor position within word)
-- Note: native `cw` only changes cursor→end-of-word; `ciw` changes the whole word
keymap("n", "<CR>", "ciw")

-- ============================================================================
-- EDITING (pure Vim — no VSCode conflicts)
-- ============================================================================

-- Join lines without moving cursor
keymap("n", "J", "mzJ`z")

-- Delete without clobbering the yank register
keymap({ "n", "v" }, "<leader>d", '"_d')

-- Copy code block (yank inside nearest {})
keymap("n", "YY", "va{Vy")

-- ============================================================================
-- CLIPBOARD
-- ============================================================================

-- Better paste (visual: replace selection without overwriting register)
keymap("x", "<leader>p", '"_dP')

-- Yank to system clipboard
keymap({ "n", "v" }, "<leader>y", '"+y')
keymap("n", "<leader>Y", '"+Y')

-- ============================================================================
-- VS CODE ACTIONS (via VSCodeNotify)
-- ============================================================================

-- Move lines up/down (works in normal + visual, cross-platform)
keymap("n", "<A-j>", ":call VSCodeNotify('editor.action.moveLinesDownAction')<CR>")
keymap("n", "<A-k>", ":call VSCodeNotify('editor.action.moveLinesUpAction')<CR>")
keymap("x", "<A-j>", ":call VSCodeNotify('editor.action.moveLinesDownAction')<CR>")
keymap("x", "<A-k>", ":call VSCodeNotify('editor.action.moveLinesUpAction')<CR>")

-- Format document
keymap("n", "<A-F>", ":call VSCodeNotify('editor.action.formatDocument')<CR>")

-- Rename symbol
keymap("n", "<leader>rn", ":call VSCodeNotify('editor.action.rename')<CR>")

-- Navigate diagnostics (errors/warnings)
keymap("n", "]d", ":call VSCodeNotify('editor.action.marker.next')<CR>")
keymap("n", "[d", ":call VSCodeNotify('editor.action.marker.prev')<CR>")

return {}
