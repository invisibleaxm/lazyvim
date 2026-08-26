-- Bootstrap lazy.nvim
-- Detect VSCode integration early
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

if vim.g.vscode then
  -- ========================================================================
  -- VSCODE MODE: Minimal config, but still load the VS Code keymap layer.
  -- ========================================================================
  vim.notify = function() end -- Disable notifications in VSCode

  -- Set leader key (must be before any keymaps)
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  -- Basic options for VSCode
  vim.opt.clipboard = "unnamedplus" -- Use system clipboard
  vim.opt.ignorecase = true          -- Case-insensitive search
  vim.opt.smartcase = true           -- Case-sensitive if uppercase present

  -- Load custom VS Code mappings before returning.
  require("plugins.vscode")
  return
end

-- ========================================================================
-- STANDALONE NEOVIM MODE: Full LazyVim configuration
-- ========================================================================
-- Load main configuration
require("config.lazy")
