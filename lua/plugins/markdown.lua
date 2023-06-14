return {
  {
    {
      "iamcco/markdown-preview.nvim",
      lazy = true,
      ft = "markdown",
      -- depends on having node and yarn installed
      -- build = "cd app && yarn install",
      -- build = ":call mkdp#util#install()",
      config = function()
        -- vim.g.mkdp_filetypes = { "markdown" },
        vim.keymap.set("n", "<C-p>", "<Esc>:MarkdownPreview<CR>", { desc = "Start MarkdownPreview" })
        vim.keymap.set("n", "<A-p>", "<Esc>:MarkdownPreviewStop<CR>", { desc = "Stop MarkdownPreview" })
        -- this is the symbol on mac, similar to alt p
        vim.keymap.set("n", "π", "<esc>:MarkdownPreviewStop<cr>", { desc = "Stop MarkdownPreview" })
      end,
    },
  },

  --pastify
  {
    "TobinPalmer/pastify.nvim",
    cmd = "Pastify",
    lazy = true,
    config = function()
      require("pastify").setup({
        opts = {
          local_path = "/docs/img/", -- The path to put local files in, ex ~/Projects/<name>/assets/images/<imgname>.png
        },
      })
    end,
  },

  {
    "krivahtoo/silicon.nvim",
    build = "./install.sh build",
    lazy = false,
    config = function()
      require("silicon").setup({
        theme = "Monokai Extended",
      })
    end,
  },
}
