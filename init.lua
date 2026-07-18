-- Bootstrap lazy.nvim
-- Detect VSCode integration early
if vim.g.vscode then
  -- VSCode extension
  vim.notify = function() end -- Disable notifications in VSCode
else
  -- Ordinary Neovim
end

-- Load main configuration
require("config.lazy")
