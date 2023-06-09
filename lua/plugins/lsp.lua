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
enable_ansiblelint = true

if vim.loop.os_uname().sysname == "Windows_NT" then
  enable_ansiblelint = false
  if vim.loop.os_gethostname() == "acampos0722" then
    enable_lualsp = false
  end
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
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "bicep-lsp",
          "shellcheck",
          "flake8", --  python code linter
          "debugpy", --python debugger
          "ruff", -- fast python linter, written in Rust.
          "black", -- python code formatter
          "isort", --organize python imports
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
        virtual_text = { prefix = "icons" },
      },
      servers = {
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
        ruff_lsp = {
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
        -- vimls = {},
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
  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   opts = function(_, opts)
  --     local nls = require("null-ls")
  --     vim.list_extend(opts.sources, {
  --       nls.builtins.diagnostics.markdownlint,
  --       nls.builtins.diagnostics.selene.with({
  --         condition = function(utils)
  --           return utils.root_has_file({ "selene.toml" })
  --         end,
  --       }),
  --       nls.builtins.formatting.isort,
  --       nls.builtins.formatting.black,
  --       nls.builtins.diagnostics.flake8,
  --       nls.builtins.diagnostics.luacheck.with({
  --         condition = function(utils)
  --           return utils.root_has_file({ ".luacheckrc" })
  --         end,
  --       }),
  --     })
  --   end,
  -- },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.diagnostics.markdownlint,
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.selene.with({
            condition = function(utils)
              return utils.root_has_file({ "selene.toml" })
            end,
          }),
          nls.builtins.formatting.isort,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.black,
          nls.builtins.diagnostics.flake8,
          nls.builtins.diagnostics.luacheck.with({
            condition = function(utils)
              return utils.root_has_file({ ".luacheckrc" })
            end,
          }),
        },
      }
    end,
  },

  -- {
  --   "mfussenegger/nvim-dap",
  --   dependencies = {
  --     "mfussenegger/nvim-dap-python",
  --     config = function()
  --       require("dap-python").setup() -- Use default python
  --     end,
  --   },
  -- },
  --
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
