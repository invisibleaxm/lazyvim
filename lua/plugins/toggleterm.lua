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
      direction = "float",
      shade_filetypes = {},
      hide_numbers = true,
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      close_on_exit = true,
      auto_scroll = true,
      shade_terminals = true,
      shading_factor = 1,
      shade_filetypes = { "none", "fzf" },
    },
  },
}
