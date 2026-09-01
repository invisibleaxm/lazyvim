-- Extra formatters/linters on top of LazyVim defaults (conform.nvim + nvim-lint).
-- Python formatting/linting comes from extras.lang.python (ruff). Install
-- remaining tools via :Mason as needed.

return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
      format_on_save = nil,
    },
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint" },
      },
    },
  },
}
