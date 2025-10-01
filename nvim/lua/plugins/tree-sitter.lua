return {
   { -- Sticky scroll, keep functions visible as they scroll off
      'nvim-treesitter/nvim-treesitter-context',
      opts = {
         max_lines = 6,
         mode = 'cursor',
         trim_scope = 'inner',
      },
   },
}
