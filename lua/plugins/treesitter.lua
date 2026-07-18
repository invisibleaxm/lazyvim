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

  --extends tree sitter default list/options available at: https://www.lazyvim.org/plugins/treesitter
  -- NOTE: Compiler is configured via vim.env.CC in lua/config/options.lua
  -- Treesitter will automatically use the CC environment variable
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "toml", "rust" })
      end

      -- Additional treesitter configuration
      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.indent = opts.indent or {}
      opts.indent.enable = true

      return opts
    end,
  },
}
