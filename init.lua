-- Bootstrap lazy.nvim
-- Detect VSCode integration early
if vim.g.vscode then
  -- ========================================================================
  -- VSCODE MODE: Minimal config, pure Neovim motions only
  -- ========================================================================
  vim.notify = function() end -- Disable notifications in VSCode

  -- Set leader key (must be before any keymaps)
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  -- Basic options for VSCode
  vim.opt.clipboard = "unnamedplus" -- Use system clipboard
  vim.opt.ignorecase = true          -- Case-insensitive search
  vim.opt.smartcase = true           -- Case-sensitive if uppercase present

  -- STOP HERE: No plugins, no LazyVim, no keymaps - pure Vim motions
  return
end

-- ========================================================================
-- STANDALONE NEOVIM MODE: Full LazyVim configuration
-- ========================================================================
-- Load main configuration
require("config.lazy")
