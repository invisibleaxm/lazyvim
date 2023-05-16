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
--vim.api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e" })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = "%s/\\s\\+$//e",
})

-- Not sure if I will use this but in case i decide to turn off autocompletion on markdowon
-- -- disable completion on markdown files by default
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "gitcommit", "markdown" },
--   callback = function()
--     require("cmp").setup({ enabled = false })
--   end,
-- })
