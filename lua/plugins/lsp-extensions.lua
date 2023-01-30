return {
   {
      "lvimuser/lsp-inlayhints.nvim",
      event = "BufReadPre",
      config = function()
         require("lsp-inlayhints").setup()
         require("lazyvim.util").on_attach(
            function(client, bufnr) require("lsp-inlayhints").on_attach(client, bufnr, false) end
         )
      end,
   },
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
         ---@type lspconfig.options
         servers = {
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
      },
   },
}
