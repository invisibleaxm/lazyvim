-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Skip VSCode-specific keymaps if running in VSCode (handled in plugins/vscode.lua)
if vim.g.vscode then
  return
end

-- Tmux sessionizer (Unix-like systems only)
if vim.fn.has("unix") == 1 then
  vim.keymap.set(
    "n",
    "<leader>fs",
    ':!tmux neww "~/.zsh_autoload_functions/tmux_sessionizer"<CR>',
    { desc = "Fuzzy find session", noremap = true, silent = true }
  )
end

-- Debugger keymaps (DAP)
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

-- Mac-specific Alt+J/K for moving lines (∆ = Alt+j, ˚ = Alt+k on Mac)
vim.keymap.set("n", "∆", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "˚", "<cmd>m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("v", "∆", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "˚", ":m '<-2<cr>gv=gv", { desc = "Move up" })
vim.keymap.set("i", "∆", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "˚", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })

-- Better line manipulation
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- Better scrolling (center cursor)
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Better paste (don't replace register)
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- System clipboard operations
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Quick copy code block
vim.keymap.set("n", "YY", "va{Vy", { desc = "Copy code block inside {}" })
vim.keymap.set("n", "<CR>", "ciw", { desc = "Map enter to ciw in normal mode" })

vim.keymap.set("n", "<leader>W", ":wa<CR>", { desc = "Write all buffers" })
vim.keymap.set("n", "<leader>Q", ":qa<CR>", { desc = "Quit all buffers" })

--- paste over highlight and not loose register contents
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste over selection preserving buffer" })
--- format file from lsp with similar to vscode shortcut alt shift f
vim.keymap.set("n", "<A-F>", function()
  vim.lsp.buf.format()
end)

-- toggle term
vim.keymap.set("v", "<F9>", ":ToggleTermSendVisualLines<CR><CR>", { desc = "send visual lines to term" })
vim.keymap.set("n", "<F9>", ":ToggleTermSendCurrentLine<CR><CR>", { desc = "send current line to terminal" })
