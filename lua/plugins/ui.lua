-- Some customizations
return {

  -- color schemes
  { "ellisonleao/gruvbox.nvim" },
  { "rebelot/kanagawa.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },

  { "nvim-tree/nvim-web-devicons" },
}
