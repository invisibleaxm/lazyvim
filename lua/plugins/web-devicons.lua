return {
  -- used to override problematic icons on noetree
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override = {
        ps1 = {
          -- icon = "",
          icon = "",
          color = "#4273ca",
          cterm_color = "68",
          name = "PsScriptfile",
        },
        ["psm1"] = {
          -- icon = "",
          icon = "",
          color = "#4273ca",
          cterm_color = "68",
          name = "PsScriptfile",
        },
        ["psd1"] = {
          -- icon = "",
          icon = "",
          color = "#4273ca",
          cterm_color = "68",
          name = "PsScriptfile",
        },
        ["dockerfile"] = {
          icon = "",
          color = "#458ee6",
          cterm_color = "68",
          name = "Dockerfile",
        },
        [".dockerignore"] = {
          icon = "",
          color = "#458ee6",
          cterm_color = "68",
          name = "Dockerfile",
        },

        -- ["ps1"] = {
        --   icon = "",
        --   color = "#4273ca",
        --   cterm_color = "68",
        --   name = "PsScriptfile",
        -- },
      },
    },
  },
}
