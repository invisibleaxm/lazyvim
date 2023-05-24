-- Some customizations
return {

  -- color schemes
  { "ellisonleao/gruvbox.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "tanvirtin/monokai.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
      -- colorscheme = "monokai_pro",
    },
  },

  { "nvim-tree/nvim-web-devicons" },
}
