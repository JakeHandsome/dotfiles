return {
   {
      "tomasiser/vim-code-dark",
      lazy = true,
      cond = false,
      --        priority = 1000,
      --        config = function()
      --            vim.cmd([[colorscheme codedark]])
      --        end
   },
   {
      "folke/tokyonight.nvim",
      lazy = true,
      cond = false,
      --        priority = 1000,
      --        config = function()
      --            vim.cmd([[colorscheme tokyonight-night]])
      --        end,
   },
   {
      "tanvirtin/monokai.nvim",
      lazy = true,
      cond = false,
      --        priority = 1000,
      --        config = function()
      --            vim.cmd([[colorscheme monokai]])
      --        end,
   },
   {
      "EdenEast/nightfox.nvim",
      build = ":NightfoxCompile",
      priority = 1000,
      cond = false,
      -- config = function() vim.cmd([[colorscheme carbonfox]]) end,
   },
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
