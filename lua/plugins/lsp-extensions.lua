return {
   {
      'lvimuser/lsp-inlayhints.nvim',
      -- Setup in autocmd
      lazy = true,
   },
   -- nvim lightbulb
   {
      'kosayoda/nvim-lightbulb',
      opts = { autocmd = { enabled = true } },
      dependencies = 'antoinemadec/FixCursorHold.nvim',
      event = "BufReadPre",
   }
}
