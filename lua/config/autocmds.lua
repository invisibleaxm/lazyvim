-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
--[[
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("docker"),
  pattern = { "Dockerfile*" },
  command = "set syntax=dockerfile",
})

]]
--
--- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
})
-- Fix conceallevel for json & help files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})

-- Associate .bicep filetype to bicep for language server support
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.bicep" },
  command = "set filetype=bicep",
})

-- trim white space
vim.api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e" })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = "%s/\\s\\+$//e",
})

-- Don't auto commenting new lines
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "",
  command = "set fo-=c fo-=r fo-=o",
})

-- Not sure if I will use this but in case i decide to turn off autocompletion on markdowon
-- -- disable completion on markdown files by default
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "gitcommit", "markdown" },
--   callback = function()
--     require("cmp").setup({ enabled = false })
--   end,
-- })
