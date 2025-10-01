return {
   'ellisonleao/gruvbox.nvim',
   priority = 1000, -- Make sure to load this before all the other start plugins.
   config = function()
      local gruvbox = require('gruvbox')
      gruvbox.setup({
         overrides = {
            LspInlayHint = {
               bg = gruvbox.palette.dark0_soft,
               fg = gruvbox.palette.light4,
               italic = true,
            },
         },
      })
      vim.cmd.colorscheme('gruvbox')
   end,
}
