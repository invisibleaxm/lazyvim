return {
  {
    {
      "iamcco/markdown-preview.nvim",
      ft = "markdown",
      -- build = "cd app && yarn install",
      build = ":call mkdp#util#install()",
      -- keys = {
      --   { "n", "<C-?>", "<Esc>:MarkdownPreview", desc = "Start MarkdownPreview" },
      --   { "n", "<A-?>", "<Esc>:MarkdownPreviewStop", desc = "Stop MarkdownPreview" },
      -- },
    },
  },
}
