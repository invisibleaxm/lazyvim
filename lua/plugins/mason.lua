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
        -- "flake8",
      },
    },
  },
}
