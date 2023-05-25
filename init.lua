-- bootstrap lazy.nvim, LazyVim and your plugins
if vim.g.vscode then
  -- vscode extension
  print("vscode")
else
  require("config.lazy")
  require("kanagawa").load("wave")
  -- Looks like the pwsh tree sitter project was abandoned but i will try to get this to work for fun
  -- if needed, this may be a location where to install custom parser for powrshell.
  -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  -- parser_config.powershell = {
  --   install_info = {
  --     url = "~/dev/personal/tree-sitter-PowerShell",
  --     files = { "src/scanner.c" },
  --   },
  --   filetype = "ps1",
  --   used_by = { "psm1", "psd1", "pssc", "psxml", "cdxml" },
  -- }
end
