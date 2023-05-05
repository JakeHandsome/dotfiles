return {
   {
      "simrat39/rust-tools.nvim",
      ft = "rs",
      opts = {
         tools = {
            on_initialized = function() require("inlay-hints").set_all() end,
            inlay_hints = {
               auto = false,
            },
         },
         server = {
            on_attach = function(c, b) require("inlay-hints").on_attach(c, b) end,
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
