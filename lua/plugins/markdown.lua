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
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    config = function()
      require("silicon").setup({
        -- Configuration here, or leave empty to use defaults
        font = "FiraCode Nerd Font=34;Symbols Nerd Font Mono=34",
        output = function()
          return "~/dev/img/" .. os.date("!%Y-%m-%dT%H-%M-%S") .. "_code.png"
        end,
      })
    end,
  },
}
