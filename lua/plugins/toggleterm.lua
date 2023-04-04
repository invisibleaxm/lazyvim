return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      {
        "<leader>td",
        "<cmd>ToggleTerm direction=horizontal<cr>",
        desc = "Open a horizontal terminal",
      },
    },
    opts = {
      terminal = "powershell",
    },
  },

  --    keys = {
  --     { “<leader>td”, “<cmd>ToggleTerm size=40 dir=~/Desktop direction=horizontal<cr>”,
  --     desc = “Open a horizontal terminal at the Desktop directory” }
  --    },
  -- },
}
