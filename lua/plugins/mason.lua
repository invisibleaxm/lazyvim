return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clang-format",
        "bicep-lsp",
        "cspell",
        "stylua",
        "shfmt",
        "jsonlint",
        "black",
        -- "flake8",
      },
    },
  },
}
