-- Some customizations
return {
  -- Colorscheme: on Omarchy, lua/plugins/omarchy-theme.lua reads the current
  -- `omarchy theme` spec. Do not pin a colorscheme here or it will fight that.

  -- Neovim splits + WezTerm/tmux/herdr panes. Do not lazy-load: mux
  -- backends (IS_NVIM / @pane-is-vim) must be set at startup.
  {
    "mrjones2014/smart-splits.nvim",
    cond = not vim.g.vscode,
    lazy = false,
    opts = {
      at_edge = "stop",
      -- Leave nil so the plugin picks wezterm / tmux / herdr from the env.
      multiplexer_integration = nil,
      disable_multiplexer_nav_when_zoomed = true,
    },
    keys = {
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        mode = { "n", "t" },
        desc = "Move to left split or mux pane",
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        mode = { "n", "t" },
        desc = "Move to lower split or mux pane",
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        mode = { "n", "t" },
        desc = "Move to upper split or mux pane",
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        mode = { "n", "t" },
        desc = "Move to right split or mux pane",
      },
      {
        "<C-A-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        mode = { "n", "t" },
        desc = "Move to left split or mux pane",
      },
      {
        "<C-A-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        mode = { "n", "t" },
        desc = "Move to lower split or mux pane",
      },
      {
        "<C-A-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        mode = { "n", "t" },
        desc = "Move to upper split or mux pane",
      },
      {
        "<C-A-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        mode = { "n", "t" },
        desc = "Move to right split or mux pane",
      },
    },
  },
}
