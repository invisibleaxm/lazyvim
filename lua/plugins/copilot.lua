-- GitHub Copilot Configuration
-- VSCODE HYBRID MODE: Disable Neovim Copilot in VSCode
-- Use VSCode's native Copilot extension instead
if vim.g.vscode then
  return {}
end

return {
  -- Copilot core settings in completion-menu mode
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = false,
          next = "<M-]>", -- Next suggestion (Alt+])
          prev = "<M-[>", -- Previous suggestion (Alt+[)
          dismiss = "<C-]>", -- Dismiss suggestion (Ctrl+])
        },
      },
      panel = {
        enabled = false,
      },
    },
  },
}
