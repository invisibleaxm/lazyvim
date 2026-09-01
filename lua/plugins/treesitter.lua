return {
  {
    "mfussenegger/nvim-treehopper",
    keys = { { "m", mode = { "o", "x" } } },
    config = function()
      vim.cmd([[
        omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
        xnoremap <silent> m :lua require('tsht').nodes()<CR>
      ]])
    end,
  },

  -- LazyVim 15+ uses the nvim-treesitter `main` branch. Only extend the
  -- ensure_installed list; do not set highlight/indent/compilers/build here.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "toml", "rust" },
    },
  },
}
