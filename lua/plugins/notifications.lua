-- Notification Configuration
-- Makes notifications stay visible longer
-- VSCODE HYBRID MODE: Disable custom notifications in VSCode
-- Use VSCode's notification system instead
if vim.g.vscode then
  return {}
end

return {
  -- Configure noice.nvim (LazyVim's notification system)
  {
    "folke/noice.nvim",
    opts = {
      -- Increase notification timeout
      notify = {
        enabled = true,
        view = "notify",
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },
      lsp = {
        progress = {
          enabled = true,
          view = "mini",
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
  },

  -- Configure nvim-notify for longer display
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000, -- Show notifications for 5 seconds (default is 3000)
      max_width = 80,
      max_height = 20,
      stages = "fade_in_slide_out",
      render = "default",
      background_colour = "#000000",
      level = vim.log.levels.INFO,

      -- Keep history of all notifications
      top_down = false,
    },
    keys = {
      -- View notification history
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
      {
        "<leader>nh",
        function()
          require("telescope").extensions.notify.notify()
        end,
        desc = "Notification History",
      },
    },
  },

  -- Telescope integration for searching notifications
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "rcarriga/nvim-notify",
        opts = function(_, opts)
          -- Register notify with telescope
          return opts
        end,
      },
    },
    keys = {
      { "<leader>sn", "<cmd>Telescope notify<cr>", desc = "Search Notifications" },
    },
  },
}
