return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clang-format",
        "cspell",
        "stylua",
        "shfmt",
        -- "flake8",
      },
    },
  },
}
