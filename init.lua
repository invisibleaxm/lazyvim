-- bootstrap lazy.nvim, LazyVim and your plugins

if vim.g.vscode then
 -- vscode extension
 print("vscode")
else 
  require("config.lazy")
end
