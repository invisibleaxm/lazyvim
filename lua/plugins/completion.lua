-- VSCODE HYBRID MODE: Disable Neovim completion in VSCode
-- Use VSCode IntelliSense instead of nvim-cmp
if vim.g.vscode then
  return {}
end

return {
  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },

  -- Copilot-cmp: Load AFTER nvim-cmp to avoid "module cmp not found" error
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "zbirenbaum/copilot.lua",
    },
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- Configure nvim-cmp for better completion behavior
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      -- ============================================================================
      -- COMPLETION BEHAVIOR (Less Aggressive)
      -- ============================================================================

      opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
        autocomplete = {
          cmp.TriggerEvent.TextChanged, -- Only on text change, not on cursor movement
        },
        completeopt = "menu,menuone,noinsert", -- Don't auto-insert first completion
        keyword_length = 1, -- Start showing completions after 1 character
      })

      -- Don't preselect first item (less aggressive)
      opts.preselect = cmp.PreselectMode.None

      -- ============================================================================
      -- KEYMAPS
      -- ============================================================================

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        -- Enter confirms only if item is explicitly selected
        ["<CR>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm({ select = true }),
          c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        }),

        -- Ctrl+E to abort/close completion menu
        ["<C-e>"] = cmp.mapping.abort(),

        -- Ctrl+Space to manually trigger completion
        ["<C-Space>"] = cmp.mapping.complete(),

        -- Tab: Smart completion handling
        -- Priority:
        -- 1. If cmp menu visible → cycle through items
        -- 2. If Copilot suggestion visible → accept it
        -- 3. If snippet expandable → expand snippet
        -- 4. If words before cursor → trigger cmp
        -- 5. Otherwise → normal tab
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            -- Check if Copilot suggestion is available
            local copilot_ok, copilot_suggestion = pcall(require, "copilot.suggestion")
            if copilot_ok and copilot_suggestion.is_visible() then
              copilot_suggestion.accept()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end
        end, { "i", "s" }),

        -- Shift+Tab cycles backwards
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      -- ============================================================================
      -- WINDOW APPEARANCE
      -- ============================================================================

      opts.window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      }

      -- ============================================================================
      -- SOURCE PRIORITIES (Ensure LSP comes before file paths)
      -- ============================================================================

      -- Configure completion sources with proper priorities
      -- LSP > Copilot > Snippets > Buffer > Path
      opts.sources = cmp.config.sources({
        { name = "nvim_lsp", group_index = 1, priority = 1000 }, -- Language server FIRST
        { name = "copilot", group_index = 1, priority = 950 }, -- Copilot second (AI suggestions)
        { name = "luasnip", group_index = 1, priority = 900 }, -- Snippets with LSP group
      }, {
        {
          name = "buffer",
          group_index = 2,
          priority = 500, -- Buffer words third
          keyword_length = 4, -- Require 4 characters before showing buffer matches (was 3)
          max_item_count = 5, -- Limit buffer suggestions to reduce noise
          option = {
            get_bufnrs = function()
              -- Only complete from visible buffers (not all open buffers)
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
          entry_filter = function(entry, ctx)
            -- Get the actual word that will be shown
            local word = entry:get_word()
            local abbr = entry.completion_item.label

            -- Filter out items with tilde suffix (disambiguators)
            if word and word:match("~$") then
              return false
            end
            if abbr and abbr:match("~$") then
              return false
            end

            return true
          end,
        },
        {
          name = "path",
          group_index = 2,
          priority = 250, -- File paths LAST (prevents func.exe before function keyword)
          keyword_length = 3, -- Require 3 characters for path completions
          max_item_count = 5, -- Reduced from 10
          option = {
            trailing_slash = true, -- Add trailing slash for directories
          },
          entry_filter = function(entry)
            local label = entry:get_insert_text()
            -- Filter out temporary and backup files
            if label:match("~$") then -- Vim/Neovim backup files (file.txt~)
              return false
            end
            if label:match("%.tmp$") then -- .tmp files
              return false
            end
            if label:match("%.temp$") then -- .temp files
              return false
            end
            if label:match("%.swp$") then -- Vim swap files
              return false
            end
            if label:match("%.swo$") then -- Vim swap files
              return false
            end
            if label:match("%.swn$") then -- Vim swap files
              return false
            end
            return true
          end,
        },
      })

      -- Sorting configuration to respect priorities
      opts.sorting = opts.sorting or {}
      opts.sorting.priority_weight = 2
      opts.sorting.comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      }

      return opts
    end,
  },
}
