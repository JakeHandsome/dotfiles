return {
   -- Plugins that need to be disabled in vscode
   --   { "NvChad/nvim-colorizer.lua", cond = vim.g.vscode == nil },
   --   { "RRethy/vim-illuminate", cond = vim.g.vscode == nil },
   --   { "lewis6991/gitsigns.nvim", cond = vim.g.vscode == nil },
   --   { "neovim/nvim-lspconfig", cond = vim.g.vscode == nil },
   --   { "hrsh7th/nvim-cmp", cond = vim.g.vscode == nil },
   --   { "williamboman/mason.nvim", cond = vim.g.vscode == nil },
   --   { "kosayoda/nvim-lightbulb", cond = vim.g.vscode == nil },
   --   { "nvim-neo-tree/neo-tree.nvim", cond = vim.g.vscode == nil },
   --   { "akinsho/toggleterm.nvim", cond = vim.g.vscode == nil },
   --   { "nvim-treesitter/nvim-treesitter", cond = vim.g.vscode == nil },
   --   { "rcarriga/nvim-notify", cond = vim.g.vscode == nil },
   --   { "stevearc/dressing.nvim", cond = vim.g.vscode == nil },
   --   { "nvim-lualine/lualine.nvim", cond = vim.g.vscode == nil },
   --   { "SmiteshP/nvim-navic", cond = vim.g.vscode == nil },
   --   { "goolord/alpha-nvim", cond = vim.g.vscode == nil },
   --   { "nvim-treesitter/nvim-treesitter", cond = vim.g.vscode == nil },
   { "folke/flash.nvim", cond = vim.g.vscode == nil },
   -- Also disable in neovide
   { "folke/noice.nvim", cond = vim.g.vscode == nil and vim.g.neovide == nil },
   -- ALways disable
   { "akinsho/bufferline.nvim", cond = false },
   -- Use different session manager
   { "folke/persistence.nvim", cond = false, keys = function() return {} end },
}
