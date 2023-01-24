return {
   "danymat/neogen",
   keys = {
      { "<leader>cc", "<cmd>Neogen<cr>", desc = "Generate documentation" }
   },
   dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      { "L3MON4D3/LuaSnip" },
   },
   config = true,
   opts = {
      snippet_engine = "luasnip",
      enabled = true,
      input_after_comment = true,
   }
   -- Uncomment next line if you want to follow only stable versions
   -- version = "*"
}
