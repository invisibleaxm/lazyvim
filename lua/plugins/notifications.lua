-- VSCODE HYBRID MODE: extras.vscode already disables Snacks notifier / Noice UI.
if vim.g.vscode then
  return {}
end

-- LazyVim uses Snacks.notifier (not nvim-notify). Keep toasts on screen a bit longer.
return {
  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        timeout = 5000,
      },
    },
  },
}
