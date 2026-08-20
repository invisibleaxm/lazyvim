-- VSCODE HYBRID MODE: Disable Neovim completion in VSCode
-- Use VSCode IntelliSense instead of nvim-cmp
if vim.g.vscode then
  return {}
end

return {
  -- Match VS Code IntelliSense: Tab/S-Tab/C-j/C-k cycle, Enter accepts.
  -- C-j/C-k have no fallback so a closed menu does not insert a newline
  -- or start a digraph (i_CTRL-K). Shells keep Ctrl+K = kill-to-EOL.
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
      opts.keymap["<Tab>"] = { "select_next", "snippet_forward", "fallback" }
      opts.keymap["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" }
      opts.keymap["<C-j>"] = { "select_next" }
      opts.keymap["<C-k>"] = { "select_prev" }
      opts.keymap["<CR>"] = { "accept", "fallback" }
      opts.keymap["<Down>"] = { "select_next", "fallback" }
      opts.keymap["<Up>"] = { "select_prev", "fallback" }

      -- Cycling does not insert (auto_insert = false) until Enter.
      opts.completion = opts.completion or {}
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.selection = { preselect = false, auto_insert = false }

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
        min_keyword_length = 5,
      })
      opts.sources.providers.copilot = vim.tbl_deep_extend("force", opts.sources.providers.copilot or {}, {
        score_offset = 15,
        min_keyword_length = 5,
        max_items = function(ctx)
          if ctx and (ctx.filetype == "ps1" or ctx.filetype == "psm1" or ctx.filetype == "psd1" or ctx.filetype == "powershell") then
            return 5
          end
          return 8
        end,
      })
      opts.sources.providers.snippets = vim.tbl_deep_extend("force", opts.sources.providers.snippets or {}, {
        score_offset = 10,
        min_keyword_length = 5,
      })
      opts.sources.providers.buffer = vim.tbl_deep_extend("force", opts.sources.providers.buffer or {}, {
        score_offset = -10,
        min_keyword_length = function(ctx)
          if ctx and (ctx.filetype == "ps1" or ctx.filetype == "psm1" or ctx.filetype == "psd1" or ctx.filetype == "powershell") then
            return 5
          end
          return 5
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
        min_keyword_length = 5,
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
