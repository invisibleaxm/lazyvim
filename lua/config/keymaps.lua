-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Skip VSCode-specific keymaps if running in VSCode (handled in plugins/vscode.lua)
if vim.g.vscode then
  return
end

-- ============================================================================
-- CLIPBOARD OPERATIONS (System clipboard integration)
-- ============================================================================

-- Yank to system clipboard (works with mouse selection too)
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Paste from system clipboard without overwriting register
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Delete without yanking (use black hole register)
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- ============================================================================
-- EDITING SHORTCUTS
-- ============================================================================

-- Join lines without moving cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })

-- Change word under cursor
vim.keymap.set("n", "<CR>", "ciw", { desc = "Change word under cursor" })

-- Copy code block (visual select inside {})
vim.keymap.set("n", "YY", "va{Vy", { desc = "Copy code block" })

-- ============================================================================
-- NAVIGATION & SCROLLING (Center cursor after movement)
-- ============================================================================

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search (centered)" })

-- ============================================================================
-- BUFFER & FILE OPERATIONS
-- ============================================================================

vim.keymap.set("n", "<leader>W", ":wa<CR>", { desc = "Write all buffers" })
vim.keymap.set("n", "<leader>Q", ":qa<CR>", { desc = "Quit all" })

-- ============================================================================
-- FORMATTING
-- ============================================================================

-- Format file with LSP (Alt+Shift+F like VSCode)
vim.keymap.set("n", "<A-F>", function()
  vim.lsp.buf.format()
end, { desc = "Format file (LSP)" })

-- ============================================================================
-- DEBUGGER (DAP)
-- ============================================================================

vim.keymap.set("n", "<F5>", function()
  require("dap").continue()
end, { desc = "DAP: Continue" })

vim.keymap.set("n", "<S-F5>", function()
  require("dap").disconnect()
  require("dap").repl.close()
end, { desc = "DAP: Stop" })

vim.keymap.set("n", "<F8>", function()
  require("dap").toggle_breakpoint()
end, { desc = "DAP: Toggle breakpoint" })

vim.keymap.set("n", "<F10>", function()
  require("dap").step_over()
end, { desc = "DAP: Step over" })

vim.keymap.set("n", "<F11>", function()
  require("dap").step_into()
end, { desc = "DAP: Step into" })

vim.keymap.set("n", "<F12>", function()
  require("dap").step_out()
end, { desc = "DAP: Step out" })

vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
  require("dap.ui.widgets").hover()
end, { desc = "DAP: Hover" })

vim.keymap.set({ "n", "v" }, "<Leader>dP", function()
  require("dap.ui.widgets").preview()
end, { desc = "DAP: Preview" })

-- ============================================================================
-- TOGGLETERM (Send code to terminal)
-- ============================================================================

vim.keymap.set("v", "<F9>", ":ToggleTermSendVisualLines<CR><CR>", { desc = "Send visual lines to term" })
vim.keymap.set("n", "<F9>", ":ToggleTermSendCurrentLine<CR><CR>", { desc = "Send current line to term" })

-- ============================================================================
-- PLATFORM-SPECIFIC KEYMAPS
-- ============================================================================

-- Mac: Alt+J/K for moving lines (∆ = Alt+j, ˚ = Alt+k on macOS)
if vim.loop.os_uname().sysname == "Darwin" then
  vim.keymap.set("n", "∆", "<cmd>m .+1<cr>==", { desc = "Move line down" })
  vim.keymap.set("n", "˚", "<cmd>m .-2<cr>==", { desc = "Move line up" })
  vim.keymap.set("v", "∆", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
  vim.keymap.set("v", "˚", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
  vim.keymap.set("i", "∆", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
  vim.keymap.set("i", "˚", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
end

-- Unix/Linux: Tmux sessionizer
if vim.fn.has("unix") == 1 then
  vim.keymap.set(
    "n",
    "<leader>fs",
    ':!tmux neww "~/.zsh_autoload_functions/tmux_sessionizer"<CR>',
    { desc = "Fuzzy find session (tmux)", noremap = true, silent = true }
  )
end
