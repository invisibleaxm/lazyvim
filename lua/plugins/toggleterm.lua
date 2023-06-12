return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = {
      {
        "<C-\\>",
        "<cmd>ToggleTerm<cr>",
        desc = "Open a floating terminal",
      },
    },
    opts = {
      -- open_mapping = [[<C-t>]],
      open_mapping = [[<C-\>]],
      direction = "horizontal",
      size = 20,
      -- direction = "float",
      hide_numbers = true,
      terminal_mappings = true,
      insert_mappings = true,
      start_in_insert = true,
      auto_scroll = true,
      close_on_exit = true,
      shade_terminals = true,
      shading_factor = "2",
      -- shade_filetypes = { "none", "fzf" },
      shade_filetypes = {},
    },
  },
}
