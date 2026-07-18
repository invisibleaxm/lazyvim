-- GitHub Copilot Configuration
-- VSCODE HYBRID MODE: Disable Neovim Copilot in VSCode
-- Use VSCode's native Copilot extension instead
if vim.g.vscode then
  return {}
end

return {
  -- Customize copilot.lua (inline ghost text suggestions)
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-j>", -- Accept full suggestion (Ctrl+J)
          accept_word = "<C-Right>", -- Accept next word (Ctrl+Right Arrow)
          accept_line = "<C-l>", -- Accept line (Ctrl+L)
          next = "<M-]>", -- Next suggestion (Alt+])
          prev = "<M-[>", -- Previous suggestion (Alt+[)
          dismiss = "<C-]>", -- Dismiss suggestion (Ctrl+])
        },
      },
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>", -- Open panel (Alt+Enter)
        },
      },
    },
  },

  -- Copilot-cmp source for completion menu
  -- Disable LazyVim's auto-loading and configure manually in completion.lua
  {
    "zbirenbaum/copilot-cmp",
    enabled = false, -- Disable here, we'll enable it properly in completion.lua
  },
}
