return {
   {
      "tpope/vim-fugitive",
      cmd = { "G", "Git" },
   },
   {
      "tveskag/nvim-blame-line",
      event = { "BufReadPre", "BufNewFile" },
      keys = {
         { "<leader>ub", "<cmd>ToggleBlameLine<cr>", desc = "Toggle git blame line" },
      },
      -- Default enable the blame
      setup = function(_, _) vim.cmd("EnableBlameLine") end,
      -- TODO: This plugin isn't working figure it out later
      cond = false,
   },
}
