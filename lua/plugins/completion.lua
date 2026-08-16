-- VSCODE HYBRID MODE: Disable Neovim completion in VSCode
-- Use VSCode IntelliSense instead of nvim-cmp
if vim.g.vscode then
  return {}
end

return {
  -- Use Ctrl+J/K to navigate, Tab to accept, and Shift+Tab to move backward.
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },

  -- Blink is the active completion engine in LazyVim defaults.
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      opts.keymap["<C-j>"] = { "select_next", "fallback" }
      opts.keymap["<C-k>"] = { "select_prev", "fallback" }
      opts.keymap["<Tab>"] = { "accept", "snippet_forward", "fallback" }
      opts.keymap["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" }
      opts.keymap["<CR>"] = { "fallback" }
      opts.keymap["<Down>"] = { "select_next", "fallback" }
      opts.keymap["<Up>"] = { "select_prev", "fallback" }

      opts.sources = opts.sources or {}
      opts.sources.per_filetype = opts.sources.per_filetype or {}
      opts.sources.providers = opts.sources.providers or {}

      -- Disable auto-triggered completion in Git commit messages; keep normal code completion unchanged.
      opts.sources.per_filetype.gitcommit = { inherit_defaults = false }

      opts.sources.per_filetype.ps1 = { inherit_defaults = false, "lsp", "copilot", "snippets", "buffer" }
      opts.sources.per_filetype.psm1 = { inherit_defaults = false, "lsp", "copilot", "snippets", "buffer" }
      opts.sources.per_filetype.psd1 = { inherit_defaults = false, "lsp", "copilot", "snippets", "buffer" }
      opts.sources.per_filetype.powershell = { inherit_defaults = false, "lsp", "copilot", "snippets", "buffer" }

      opts.sources.providers.lsp = vim.tbl_deep_extend("force", opts.sources.providers.lsp or {}, {
        score_offset = 20,
      })
      opts.sources.providers.copilot = vim.tbl_deep_extend("force", opts.sources.providers.copilot or {}, {
        score_offset = 15,
        max_items = function(ctx)
          if ctx and (ctx.filetype == "ps1" or ctx.filetype == "psm1" or ctx.filetype == "psd1" or ctx.filetype == "powershell") then
            return 5
          end
          return 8
        end,
      })
      opts.sources.providers.snippets = vim.tbl_deep_extend("force", opts.sources.providers.snippets or {}, {
        score_offset = 10,
      })
      opts.sources.providers.buffer = vim.tbl_deep_extend("force", opts.sources.providers.buffer or {}, {
        score_offset = -10,
        min_keyword_length = function(ctx)
          if ctx and (ctx.filetype == "ps1" or ctx.filetype == "psm1" or ctx.filetype == "psd1" or ctx.filetype == "powershell") then
            return 5
          end
          return 4
        end,
        max_items = function(ctx)
          if ctx and (ctx.filetype == "ps1" or ctx.filetype == "psm1" or ctx.filetype == "psd1" or ctx.filetype == "powershell") then
            return 3
          end
          return 5
        end,
        transform_items = function(_, items)
          return vim.tbl_filter(function(item)
            local label = item.label or ""
            return not label:match("~$")
          end, items)
        end,
      })
      opts.sources.providers.path = vim.tbl_deep_extend("force", opts.sources.providers.path or {}, {
        score_offset = -20,
        min_keyword_length = 3,
        max_items = 5,
        transform_items = function(_, items)
          return vim.tbl_filter(function(item)
            local label = item.label or ""
            return not (
              label:match("~$")
              or label:match("%.tmp$")
              or label:match("%.temp$")
              or label:match("%.swp$")
              or label:match("%.swo$")
              or label:match("%.swn$")
            )
          end, items)
        end,
      })
    end,
  },
}
