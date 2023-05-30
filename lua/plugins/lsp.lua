--------------------------------------------------------------------------------
-- ENABLE CAPABILITIES FOR PLUGINS

local lspCapabilities = vim.lsp.protocol.make_client_capabilities()

-- Enable snippets-completion (for nvim_cmp)
lspCapabilities.textDocument.completion.completionItem.snippetSupport = true

-- Enable folding (for nvim-ufo)
lspCapabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local enable_lualsp = true

if vim.loop.os_uname().sysname == "Windows_NT" and vim.loop.os_gethostname() == "acampos0722" then
  enable_lualsp = false
end

--------------------------------------------------------------------------------

local function setupAllLsps()
  -- INFO must be before the lsp-config setup of lua-ls
  require("neodev").setup({
    library = { plugins = false }, -- plugins are helpful e.g. for plenary, but slow down lsp loading
  })

  for _, lsp in pairs(lsp_servers) do
    local config = {
      capabilities = lspCapabilities,
      settings = lspSettings[lsp], -- if no settings, will assign nil and therefore do nothing
      on_attach = lspOnAttach[lsp], -- mostly disables some settings
    }

    require("lspconfig")[lsp].setup(config)
  end
end
--------------------------------------------------------------------------------

return {
  -- tools
  { -- package manager
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- https://github.com/mason-org/mason-registry/tree/main/packages
        "bicep-lsp",
        "prettierd",
        "stylua",
        -- "luacheck", -- requires luarocks, need to research
        "shellcheck",
        "shfmt",
        "black",
        "isort", --organize python imports
        "markdownlint",
        "clang-format",
        "cspell",
        "jsonlint",
      })
    end,
  },

  -- detect ansible file type
  { "pearofducks/ansible-vim" },
  -- lsp servers

  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type lspconfig.options
      diagnostics = {
        underline = false,
        virtual_text = { prefix = "icons" },
      },
      servers = {
        azure_pipelines_ls = {},
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
        powershell_es = {
          settings = {
            powershell = {
              codeFormatting = {
                autoCorrectAliases = true,
                useCorrectCasing = true,
                preset = "OTBS",
                trimWhitespaceAroundPipe = true,
                whitespaceBetweenParameters = true,
              },
              scriptAnalysis = {
                enable = true,
              },
            },
          },
        },
        ansiblels = {},
        bashls = {},
        clangd = {},
        dockerls = {},
        ruff_lsp = {},
        tsserver = {
          single_file_support = false,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        html = {},
        -- gopls = {}, needs go language, enable when ready
        pyright = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              procMacro = { enable = true },
              cargo = { allFeatures = true },
              -- checkOnSave = {
              --   command = "clippy",
              --   extraArgs = { "--no-deps" },
              -- },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        lua_ls = {
          enabled = enable_lualsp,
          -- cmd = { "/home/folke/projects/lua-language-server/bin/lua-language-server" },
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  "--log-level=trace",
                },
              },
              diagnostics = {
                -- enable = false,
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
        vimls = {},
        -- tailwindcss = {},
      },
      init = setupAllLsps,
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
  },

  -- null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.diagnostics.markdownlint,
        nls.builtins.diagnostics.selene.with({
          condition = function(utils)
            return utils.root_has_file({ "selene.toml" })
          end,
        }),
        nls.builtins.formatting.isort,
        nls.builtins.formatting.black,
        nls.builtins.diagnostics.flake8,
        nls.builtins.diagnostics.luacheck.with({
          condition = function(utils)
            return utils.root_has_file({ ".luacheckrc" })
          end,
        }),
      })
    end,
  },

  -- I need to research this a bit more
  -- inlay hints
  --   {
  --     "lvimuser/lsp-inlayhints.nvim",
  --     event = "LspAttach",
  --     opts = {},
  --     config = function(_, opts)
  --       require("lsp-inlayhints").setup(opts)
  --       vim.api.nvim_create_autocmd("LspAttach", {
  --         group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
  --         callback = function(args)
  --           if not (args.data and args.data.client_id) then
  --             return
  --           end
  --           local client = vim.lsp.get_client_by_id(args.data.client_id)
  --           require("lsp-inlayhints").on_attach(client, args.buf)
  --         end,
  --       })
  --     end,
  --   },
}
