-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- ============================================================================
-- CURSOR LINE (only in active window)
-- ============================================================================

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
})

-- ============================================================================
-- FILETYPE-SPECIFIC SETTINGS
-- ============================================================================

-- JSON files: disable concealing and spell check
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})

-- Bicep files: set filetype for LSP support
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.bicep",
  command = "set filetype=bicep",
})

-- Azure DevOps pipeline files: special YAML filetype
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*/azure-pipeline*.y*l", "*/pipeline*/*.y*l" },
  command = "set filetype=yaml.azdevops",
})

-- ============================================================================
-- FORMATTING
-- ============================================================================

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Disable auto-commenting on new lines
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})
