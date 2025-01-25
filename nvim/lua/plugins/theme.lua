return
{
   {
      "ellisonleao/gruvbox.nvim",
      priority = 1000,
      config = function()
         vim.o.background = "dark"
         vim.cmd([[colorscheme gruvbox]])
      end,
   },
   -- Configure LazyVim to load gruvbox
   {
      "LazyVim/LazyVim",
      opts = {
         colorscheme = "gruvbox",
      },
   },
}
