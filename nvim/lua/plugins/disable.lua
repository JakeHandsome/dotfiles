return {
   { "akinsho/bufferline.nvim", enabled = false },

   -- Disable when using NixOs
   { "mason-lspconfig.nvim", enabled = not vim.g.NixOs },
   { "mason-nvim-dap.nvim", enabled = false },
   { "mason.nvim", enabled = not vim.g.NixOs },
}
