-- Formatting and Linting Configuration
-- LazyVim already includes conform.nvim and nvim-lint by default
-- This file provides additional configuration and tool specifications
--
-- To use these formatters/linters, install them via Mason:
-- :Mason
-- Then install: stylua, black, isort, shfmt, flake8, markdownlint, luacheck

return {
  -- Conform.nvim (formatting) - already included by LazyVim
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        -- Add more formatters as needed after installing via Mason
      },
      -- Disable format on save initially (enable when you have formatters installed)
      format_on_save = nil,
      -- Or enable format on save after installing formatters:
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true,
      -- },
    },
  },

  -- nvim-lint (linting) - already included by LazyVim
  -- Disabled by default to avoid errors when linters aren't installed
  -- Uncomment and configure after installing linters via Mason
  -- {
  --   "mfussenegger/nvim-lint",
  --   optional = true,
  --   opts = {
  --     linters_by_ft = {
  --       python = { "flake8" },
  --       markdown = { "markdownlint" },
  --       lua = { "luacheck" },
  --     },
  --   },
  -- },
}
