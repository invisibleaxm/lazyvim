-- VSCODE HYBRID MODE: Disable Neo-tree in VSCode
-- Use VSCode's Explorer sidebar instead
if vim.g.vscode then
  return {}
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
      filesystem = {
        filtered_items = {
          hide_dotfiles = true,
        },
      },
    },
  },
}
