return {
   -- {
   --    "gnikdroy/projections.nvim",
   --    keys = {
   --       { "<leader>fw", "<cmd>Telescope projections<cr>", desc = "Find workspaces" },
   --    },
   --    event = "VeryLazy",
   --    config = function()
   --       require("projections").setup({})
   --       require("telescope").load_extension("projections")
   --       -- Autostore session on VimExit
   --       local Session = require("projections.session")
   --       vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
   --          callback = function() Session.store(vim.loop.cwd()) end,
   --       })
   --
   --       -- Switch to project if vim was started in a project dir
   --       local switcher = require("projections.switcher")
   --       vim.api.nvim_create_autocmd({ "VimEnter" }, {
   --          callback = function()
   --             if vim.fn.argc() == 0 then
   --                switcher.switch(vim.loop.cwd())
   --             end
   --          end,
   --       })
   --    end,
   -- },
   {
      "jedrzejboczar/possession.nvim",
      keys = {
         { "<leader>fs", "<cmd>Telescope possession list<cr>", desc = "Sessions list" },
      },
      event = "VeryLazy",
      opts = {
         autosave = { current = true, tmp = true, tmp_name = "temp", on_quit = true },
      },
      config = function(_, opts)
         require("possession").setup(opts)
         require("telescope").load_extension("possession")
      end,
   },
}
