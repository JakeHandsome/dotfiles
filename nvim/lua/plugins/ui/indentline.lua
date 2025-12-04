return {
   {
      -- This plugin highlights the active line
      'nvim-mini/mini.indentscope',
      opts = function()
         vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { link = '@punctuation.bracket' })
         return {
            symbol = '▎',
            options = { try_as_border = true },
         }
      end,
   },
   { -- Add indentation guides only on blank lines
      'lukas-reineke/indent-blankline.nvim',
      -- Enable `lukas-reineke/indent-blankline.nvim`
      -- See `:help ibl`
      main = 'ibl',
      opts = { scope = { enabled = false } },
   },
}
