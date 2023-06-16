-- Some customizations
return {

  -- color schemes
  -- { "ellisonleao/gruvbox.nvim" },
  { "rebelot/kanagawa.nvim" },
  -- { "tanvirtin/monokai.nvim" },
  -- { "catppuccin/nvim", name = "catppuccin" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
      -- colorscheme = "monokai_pro",
    },
  },

  --integrated tmux navigation, requires config on tmux to make it smooth
  {
    "aserowy/tmux.nvim",
    opts = {
      resize = {
        enable_default_keybindings = false,
      },
    },
  },
}
