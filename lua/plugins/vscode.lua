-- VSCode-specific configuration
if not vim.g.vscode then
  return {}
end

-- Suppress vscode-neovim noise from webview focus (Copilot chat, output panels, etc.)
-- vim.notify only catches Lua-level messages; the real error is an RPC response
-- from nvim_set_current_win being called with a stale window id (e.g. after
-- Copilot Chat / any webview steals focus). Patching the API avoids the error
-- being generated at all, which prevents the VS Code notification.
local _orig_set_current_win = vim.api.nvim_set_current_win
vim.api.nvim_set_current_win = function(win)
  if vim.api.nvim_win_is_valid(win) then
    _orig_set_current_win(win)
  end
end

local _orig_win_set_cursor = vim.api.nvim_win_set_cursor
vim.api.nvim_win_set_cursor = function(win, pos)
  if vim.api.nvim_win_is_valid(win) then
    _orig_win_set_cursor(win, pos)
  end
end

local _orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" and msg:match("Invalid window id") then
    return
  end
  _orig_notify(msg, level, opts)
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

keymap("n", "<A-h>", ":call VSCodeNotify('workbench.action.navigateLeft')<CR>")
keymap("n", "<A-l>", ":call VSCodeNotify('workbench.action.navigateRight')<CR>")

-- Line movement: pure Vim operations (vscode-neovim syncs the buffer back)
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
keymap("x", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
  keymap("x", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })

-- Format document
keymap("n", "<A-F>", ":call VSCodeNotify('editor.action.formatDocument')<CR>")

-- File operations
keymap("n", "<leader>W", ":call VSCodeNotify('workbench.action.files.saveAll')<CR>")
keymap("n", "<leader>Q", ":call VSCodeNotify('workbench.action.closeAllEditors')<CR>")

-- Navigate diagnostics (errors/warnings)
keymap("n", "]d", ":call VSCodeNotify('editor.action.marker.next')<CR>")
keymap("n", "[d", ":call VSCodeNotify('editor.action.marker.prev')<CR>")

-- Mac: VS Code receives composed Option characters instead of Alt chords (skip WezTerm)
local term_program = vim.env.TERM_PROGRAM or ""
local is_wezterm = term_program:lower():find("wezterm") ~= nil
if vim.loop.os_uname().sysname == "Darwin" and not is_wezterm then
  -- Option+h/l on Mac often become ˙/¬, so map both normal and insert modes.
  keymap("n", "˙", ":call VSCodeNotify('workbench.action.navigateLeft')<CR>")
  keymap("n", "¬", ":call VSCodeNotify('workbench.action.navigateRight')<CR>")
  keymap("i", "˙", "<esc>:call VSCodeNotify('workbench.action.navigateLeft')<CR>")
  keymap("i", "¬", "<esc>:call VSCodeNotify('workbench.action.navigateRight')<CR>")

  -- Option+j/k on Mac often become ∆/˚; keep mode-specific move behavior.
  keymap("n", "∆", "<cmd>m .+1<cr>==", { desc = "Move line down" })
  keymap("n", "˚", "<cmd>m .-2<cr>==", { desc = "Move line up" })
  keymap("x", "∆", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
  keymap("x", "˚", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
  keymap("i", "∆", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down (insert)" })
  keymap("i", "˚", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up (insert)" })
end

return {}
