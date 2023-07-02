return {
   "akinsho/toggleterm.nvim",
   cmd = "ToggleTerm",
   opts = {
      autochdir = true,
      float_opts = {
         border = "curved",
      },
   },
   keys = {
      { "<leader>ft", "<cmd>ToggleTerm dir=git_dir direction=float<cr>", { desc = "ToggleTerm float (git_dir)" } },
      { "<leader>fT", "<cmd>ToggleTerm direction=float<cr>", { desc = "ToggleTerm float (cwd)" } },
   },
}
