return {
  {
    {
      "iamcco/markdown-preview.nvim",
      ft = "markdown",
      -- depends on having node and yarn installed
      build = "cd app && yarn install",
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
}
