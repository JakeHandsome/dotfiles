return {
   'nvim-lualine/lualine.nvim',
   dependencies = { 'nvim-tree/nvim-web-devicons'},
config = true,
cond = vim.g.vscode == nil,
   event = "VeryLazy",
}
