return {
   "nvim-treesitter/nvim-treesitter-context",
   event = { "BufReadPost", "BufNewFile" },
   opts = {
      max_lines = 6,
      mode = "cursor",
      trim_scope = "inner",
   },
}
