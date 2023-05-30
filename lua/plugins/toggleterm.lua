return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    cmd = "ToggleTerm",
    keys = {
      {
        "<C-t>",
        "<cmd>ToggleTerm<cr>",
        desc = "Open a floating terminal",
      },
    },
    opts = {
      open_mapping = [[<C-t>]],
      -- direction = "horizontal",
      -- size = 20,
      direction = "float",
      hide_numbers = true,
      terminal_mappings = true,
      insert_mappings = true,
      start_in_insert = true,
      auto_scroll = true,
      close_on_exit = true,
      shade_terminals = true,
      shading_factor = 1,
      shade_filetypes = { "none", "fzf" },
      -- shade_filetypes = {},
    },
  },
}
