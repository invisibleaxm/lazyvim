-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- local Util = require("lazyvim.util")
--
-- local function map(mode, lhs, rhs, opts)
--   local keys = require("lazy.core.handler").handlers.keys
--   ---@cast keys LazyKeysHandler
--   -- do not create the keymap if a lazy keys handler exists
--   if not keys.active[keys.parse({ lhs, mode = mode }).id] then
--     opts = opts or {}
--     opts.silent = opts.silent ~= false
--     vim.keymap.set(mode, lhs, rhs, opts)
--   end
-- end
--
-- map("n", "∆", "<cmd>m .+1<cr>==", { desc = "Move down" })
-- map("n", "˚", "<cmd>m .-2<cr>==", { desc = "Move up" })
-- map("v", "∆", ":m '>+1<cr>gv=gv", { desc = "Move down" })
-- map("v", "˚", ":m '<-2<cr>gv=gv", { desc = "Move up" })
-- map("i", "∆", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
-- map("i", "˚", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
--
-- map("n", "<C-p>", "<esc>:MarkdownPreview<cr>", { desc = "Start MarkdownPreview" })
-- map("n", "<A-p>", "<esc>:MarkdownPreviewStop<cr>", { desc = "Stop MarkdownPreview" })
-- map("n", "π", "<esc>:MarkdownPreviewStop<cr>", { desc = "Stop MarkdownPreview" })
-- These keymaps help when working on mac as the modifier keys for alt and option key have differnet meaning inside vim

-- -- move lines/highlights by pressing alt and movement up/down keys like jk
-- vim.keymap.set(
--   "n",
--   "<C-f>",
--   ':!tmux neww "~/.zsh_autoload_functions/tmux_sessionizer"<CR>',
--   { noremap = true, silent = true }
-- )
--

-- map("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
-- map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

vim.keymap.set("n", "∆", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "˚", "<cmd>m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("v", "∆", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "˚", ":m '<-2<cr>gv=gv", { desc = "Move up" })
vim.keymap.set("i", "∆", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "˚", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })

-- J appends line below to end of line, this remap keeps the cursor in current position
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- vim.keymap.set("n", "<C-p>", "<esc>:MarkdownPreview<cr>", { desc = "Start MarkdownPreview" })
-- vim.keymap.set("n", "<A-p>", "<esc>:MarkdownPreviewStop<cr>", { desc = "Stop MarkdownPreview" })
-- vim.keymap.set("n", "π", "<esc>:MarkdownPreviewStop<cr>", { desc = "Stop MarkdownPreview" })

-- vim.keymap.set("n", "<silent> <C-+>", ":silent !tmux neww tmux_sessionizer<CR>", { desc = "tmux sessioniser" })

vim.keymap.set("n", "YY", "va{Vy", { desc = "Copy code block inside { and } including brackets" })
vim.keymap.set("n", "<CR>", "ciw", { desc = "Map enter to ciw in normal mode" })

vim.keymap.set("n", "<leader>W", ":wa<CR>", { desc = "Write all buffers" })
vim.keymap.set("n", "<leader>Q", ":qa<CR>", { desc = "Quit all buffers" })

--- paste over highlight and not loose register contents
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste over selection preserving buffer" })
--- format file from lsp with similar to vscode shortcut alt shift f
vim.keymap.set("n", "<A-F>", function()
  vim.lsp.buf.format()
end)
