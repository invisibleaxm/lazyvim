--------------------------------------------------------------------------------
-- ENABLE CAPABILITIES FOR PLUGINS
-- VSCODE HYBRID MODE: Disable LSP servers in VSCode
-- Use VSCode's language servers instead

if vim.g.vscode then
  return {}
end

local enable_lualsp = true
local enable_ansiblelint = true

if vim.loop.os_uname().sysname == "Windows_NT" then
  enable_ansiblelint = false
  if vim.loop.os_gethostname() == "acampos0722" then
    enable_lualsp = false
  end
end

--------------------------------------------------------------------------------

return {
  -- tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "bicep-lsp",
          "shellcheck",
          "debugpy",
          "ruff",
          "markdownlint",
          "clang-format",
          "cspell",
          "jsonlint",
        })
      end
    end,
  },

  -- detect ansible file type
  { "pearofducks/ansible-vim", enabled = enable_ansiblelint },
  -- lsp servers

  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type lspconfig.options
      diagnostics = {
        underline = false,
        virtual_text = false,
        signs = true,
      },
      servers = {
        ["*"] = {
          capabilities = {
            textDocument = {
              completion = {
                completionItem = { snippetSupport = true },
              },
              -- Enable folding (for nvim-ufo's "lsp" fold provider)
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
        },
        azure_pipelines_ls = {
          filetypes = { "yaml.azdevops" },
          settings = {
            yaml = {
              schemas = {
                ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
                  "/azure-pipeline*.y*l",
                  "Pipelines/*.y*l",
                },
              },
            },
          },
        },
        marksman = {},
        -- powershell_es configuration moved to lua/plugins/powershell.lua for better organization
        ansiblels = {
          -- settings = {
          --   validation = {
          --     enabled = enable_ansiblelint,
          --   },
          -- },
        },
        bashls = {},
        -- clangd = {},
        dockerls = {},
        -- html = {},
        -- gopls = {}, needs go language, enable when ready
        pyright = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                typeCheckingMode = "off",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace", -- "openFilesOnly",
              },
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              args = { "--max-line-length=180" },
            },
          },
        },
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
        -- vimls = {},
        -- tailwindcss = {},
      },
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
  },
}
