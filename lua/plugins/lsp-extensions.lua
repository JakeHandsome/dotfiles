local handler = function(virtText, lnum, endLnum, width, truncate)
   local newVirtText = {}
   local suffix = ("  %d "):format(endLnum - lnum)
   local sufWidth = vim.fn.strdisplaywidth(suffix)
   local targetWidth = width - sufWidth
   local curWidth = 0
   for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
         table.insert(newVirtText, chunk)
      else
         chunkText = truncate(chunkText, targetWidth - curWidth)
         local hlGroup = chunk[2]
         table.insert(newVirtText, { chunkText, hlGroup })
         chunkWidth = vim.fn.strdisplaywidth(chunkText)
         -- str width returned from truncate() may less than 2nd argument, need padding
         if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
         end
         break
      end
      curWidth = curWidth + chunkWidth
   end
   table.insert(newVirtText, { suffix, "MoreMsg" })
   return newVirtText
end

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
   -- Setup folds
   {
      "kevinhwang91/nvim-ufo",
      dependencies = "kevinhwang91/promise-async",
      event = "BufRead",
      opts = {
         fold_virt_text_handler = handler,
      },
      keys = {
         { "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds" } },
         { "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" } },
      },
   },
}
