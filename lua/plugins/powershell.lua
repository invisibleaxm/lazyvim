-- PowerShell Development Configuration
-- VSCODE HYBRID MODE: Disable PowerShell LSP in VSCode
-- Use VSCode's PowerShell extension instead
-- Keep keymaps for consistency

if vim.g.vscode then
  return {}
end

return {
  -- PowerShell LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        powershell_es = {
          -- PowerShell Editor Services settings
          bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
          shell = "pwsh", -- Use PowerShell 7+ (or "powershell" for Windows PowerShell)
          settings = {
            powershell = {
              -- Code formatting preferences
              codeFormatting = {
                autoCorrectAliases = true, -- Expand aliases to full cmdlet names
                avoidSemicolonsAsLineTerminators = true, -- PowerShell style
                useCorrectCasing = true, -- Proper PascalCase for cmdlets
                preset = "OTBS", -- One True Brace Style
                trimWhitespaceAroundPipe = true,
                whitespaceBetweenParameters = true,
                whitespaceBeforeOpenBrace = true,
                whitespaceBeforeOpenParen = true,
                whitespaceAroundOperator = true,
                whitespaceAfterSeparator = true,
                ignoreOneLineBlock = true,
                alignPropertyValuePairs = true,
                pipelineIndentationStyle = "IncreaseIndentationForFirstPipeline",
              },

              -- Script analysis (PSScriptAnalyzer)
              scriptAnalysis = {
                enable = true,
                settingsPath = "", -- Path to PSScriptAnalyzerSettings.psd1 if you have custom rules
              },

              -- IntelliSense/Completion settings
              integratedConsole = {
                showOnStartup = false,
                focusConsoleOnExecute = false,
              },

              -- Improve performance
              enableProfileLoading = false, -- Faster startup, disable if you need profile
              helpCompletion = "BlockComment", -- Use <# #> style for help

              -- Debugging
              debugging = {
                createTemporaryIntegratedConsole = false,
              },
            },
          },

          -- Custom on_attach to add PowerShell-specific keymaps
          on_attach = function(client, bufnr)
            local map = vim.keymap.set
            local opts = { buffer = bufnr, silent = true }

            -- PowerShell-specific keymaps
            map("n", "<leader>pr", ":!pwsh -File %<CR>", vim.tbl_extend("force", opts, { desc = "Run PS script" }))
            map(
              "n",
              "<leader>pt",
              ":!pwsh -Command Invoke-Pester<CR>",
              vim.tbl_extend("force", opts, { desc = "Run Pester tests" })
            )
            map(
              "n",
              "<leader>pa",
              ":!pwsh -Command Invoke-ScriptAnalyzer -Path %<CR>",
              vim.tbl_extend("force", opts, { desc = "Analyze script" })
            )
            map("n", "<leader>ph", ":!pwsh -Command Get-Help ", vim.tbl_extend("force", opts, { desc = "Get help" }))

            -- Format with LSP
            map("n", "<leader>pf", function()
              vim.lsp.buf.format({ async = true })
            end, vim.tbl_extend("force", opts, { desc = "Format PS file" }))
          end,
        },
      },
    },
  },

  -- Treesitter PowerShell support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Add PowerShell to ensure_installed if not already there
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "powershell" })
      end

      return opts
    end,
  },

  -- Auto-completion tuning for PowerShell
  {
    "hrsh7th/nvim-cmp",
    -- Filetype-specific overrides for PowerShell
    config = function()
      -- Apply settings when entering PowerShell files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "ps1", "psm1", "psd1" },
        callback = function()
          local cmp = require("cmp")

          -- PowerShell-specific completion: LSP first, then Copilot, minimal buffer/path
          cmp.setup.buffer({
            sources = {
              { name = "nvim_lsp", priority = 1000, max_item_count = 30 }, -- PowerShell LSP FIRST
              { name = "copilot", priority = 950, max_item_count = 5 }, -- Copilot second
              { name = "luasnip", priority = 900, max_item_count = 10 }, -- Snippets third
              {
                name = "buffer",
                priority = 300,
                keyword_length = 5, -- Need 5 chars before buffer shows
                max_item_count = 3,
                option = {
                  get_bufnrs = function()
                    return { vim.api.nvim_get_current_buf() }
                  end,
                },
              },
              -- path disabled for PowerShell
            },
          })
        end,
      })
    end,
  },

  -- Mason: Ensure PowerShell tools are installed
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "powershell-editor-services", -- PowerShell LSP
      })
    end,
  },

  -- Add PowerShell snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Custom PowerShell snippets
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node

      ls.add_snippets("ps1", {
        s("func", {
          t("function "),
          i(1, "FunctionName"),
          t(" {"),
          t({ "", "    param(" }),
          i(2),
          t({ ")", "" }),
          t({ "    ", "    " }),
          i(0),
          t({ "", "}" }),
        }),

        s("param", {
          t("[Parameter("),
          i(1, "Mandatory=$true"),
          t(")]"),
          t({ "", "[" }),
          i(2, "string"),
          t("]$"),
          i(3, "ParameterName"),
        }),

        s("try", {
          t({ "try {", "    " }),
          i(1),
          t({ "", "} catch {" }),
          t({ "", '    Write-Error "' }),
          i(2, "Error message"),
          t(': $($_.Exception.Message)"'),
          t({ "", "}" }),
        }),

        s("foreach", {
          t("foreach ($"),
          i(1, "item"),
          t(" in $"),
          i(2, "collection"),
          t({ ") {", "    " }),
          i(0),
          t({ "", "}" }),
        }),

        s("help", {
          t({ "<#", ".SYNOPSIS", "    " }),
          i(1, "Brief description"),
          t({ "", ".DESCRIPTION", "    " }),
          i(2, "Detailed description"),
          t({ "", ".PARAMETER " }),
          i(3, "ParameterName"),
          t({ "", "    " }),
          i(4, "Parameter description"),
          t({ "", ".EXAMPLE", "    " }),
          i(5, "Example usage"),
          t({ "", "#>" }),
        }),
      })
    end,
  },

  -- ToggleTerm PowerShell integration
  {
    "akinsho/toggleterm.nvim",
    opts = function(_, opts)
      -- Add PowerShell terminal configuration
      local Terminal = require("toggleterm.terminal").Terminal

      -- Create a PowerShell terminal instance
      local pwsh = Terminal:new({
        cmd = "pwsh -NoLogo",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })

      -- Function to toggle PowerShell terminal
      function _G.pwsh_toggle()
        pwsh:toggle()
      end

      -- Keymap for PowerShell terminal
      vim.keymap.set("n", "<leader>pp", "<cmd>lua pwsh_toggle()<CR>", { desc = "Toggle PowerShell terminal" })

      return opts
    end,
  },
}
