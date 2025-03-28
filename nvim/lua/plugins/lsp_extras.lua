vim.g.rustaceanvim = {
   -- LSP configuration
   server = {
      on_attach = function(client, bufnr)
         -- you can also put keymaps in here
      end,
      default_settings = {
         -- rust-analyzer language server configuration
         ["rust-analyzer"] = {
            diagnostics = {
               disabled = "unlinked-file",
               experimental = {
                  enable = true,
               },
            },
         },
      },
   },
}

return {
   -- nvim lightbulb
   {
      "kosayoda/nvim-lightbulb",
      opts = { autocmd = { enabled = true } },
      dependencies = "antoinemadec/FixCursorHold.nvim",
      event = "BufReadPre",
   },
   {
      "neovim/nvim-lspconfig",
      ---@class PluginLspOpts
      opts = {
         -- enable inlay hints by default
         inlay_hints = { enabled = true },
         ---@type lspconfig.options
         servers = {
            jsonls = {
               settings = {
                  json = {
                     schemas = require("schemastore").json.schemas({
                        extra = {
                           {
                              name = "ControllerAbstractionSchema.json",
                              description = "CA2 json schemas",
                              fileMatch = { "*.sysarch" },
                              url = "file:"
                                 .. vim.fn.getcwd()
                                 .. "/node_modules/@deere-embedded/isg-embedded-tools.code-generation/Publish/ControllerAbstraction2.0/Schema/ControllerAbstractionSchema.json",
                           },
                        },
                     }),
                  },
               },
            },
            lua_ls = {},
            -- nil_ls = {},
            nixd = {
               enabled = vim.g.NixOs,
               settings = {
                  nixd = {
                     nixpkgs = {
                        expr = "import <nixpkgs> {}",
                     },
                     formatting = { command = { "nixfmt" } },
                     options = {
                        nixos = {
                           expr = '(builtins.getFlake "/home/jake/nix-config").nixosConfigurations.jake-nixos-desktop.options',
                        },
                     },
                  },
               },
            },
            -- Setup tsserver following lsp-inlayhints docs
            tsserver = {
               settings = {
                  typescript = {
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
         },
         -- you can do any additional lsp server setup here
         -- return true if you don't want this server to be setup with lspconfig
         ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
         setup = {
            -- example to setup with typescript.nvim
            -- tsserver = function(_, opts)
            --   require("typescript").setup({ server = opts })
            --   return true
            -- end,
            -- Specify * to use this function as a fallback for any server
            ["*"] = function(_, opts)
               -- Setup fold capabilities for ufo nvim
               opts.capabilities.textDocument.foldingRange = {
                  dynamicRegistration = false,
                  lineFoldingOnly = true,
               }
               -- Setup borders
               opts.handlers = {
                  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
                  ["textDocument/signatureHelp"] = vim.lsp.with(
                     vim.lsp.handlers.signature_help,
                     { border = "rounded" }
                  ),
               }
            end,
         },
      },
   },
}
