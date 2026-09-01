-- VSCODE HYBRID MODE: extra is already blocked by extras.vscode cond.
-- Keep this file as Neo-tree *opts* only; keymaps/lazy-load come from
-- lazyvim.plugins.extras.editor.neo-tree.
if vim.g.vscode then
  return {}
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      filesystem = {
        filtered_items = {
          hide_dotfiles = true,
        },
      },
    },
  },
}
