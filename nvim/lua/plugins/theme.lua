return {
   {
      "tomasiser/vim-code-dark",
      lazy = true,
      --        priority = 1000,
      --        config = function()
      --            vim.cmd([[colorscheme codedark]])
      --        end
   },
   {
      "folke/tokyonight.nvim",
      lazy = true,
      --        priority = 1000,
      --        config = function()
      --            vim.cmd([[colorscheme tokyonight-night]])
      --        end,
   },
   {
      "tanvirtin/monokai.nvim",
      lazy = false,
      --        priority = 1000,
      --        config = function()
      --            vim.cmd([[colorscheme monokai]])
      --        end,
   },
   {
      "EdenEast/nightfox.nvim",
      build = ":NightfoxCompile",
      priority = 1000,
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
}
