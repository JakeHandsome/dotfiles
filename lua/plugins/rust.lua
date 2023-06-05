return {
   {
      "simrat39/rust-tools.nvim",
      ft = "rs",
      opts = {
         tools = {
            inlay_hints = {
               auto = false,
            },
         },
      },
      keys = {
         {
            "<leader>re",
            function() require("rust-tools").expand_macro.expand_macro() end,
            desc = "Expand Macro recursively",
         },
         { "<leader>rr", function() require("rust-tools").runnables.runnables() end, desc = "Runnables" },
         { "<leader>rp", function() require("rust-tools").parent_module.parent_module() end, desc = "Parent Module" },
         { "<leader>rc", "<cmd>RustViewCrateGraph<cr>", desc = "View crate graph" },
      },
   },
   {
      "folke/which-key.nvim",
      -- Add rust key binds
      opts = function(_, opts) opts.defaults["<leader>r"] = { name = "+rust" } end,
   },
}
