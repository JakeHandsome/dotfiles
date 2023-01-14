return{
   "akinsho/toggleterm.nvim", 
   version = '*', 
   cmd = "ToggleTerm",
   init = function()
        require("which-key").register({
            ["<leader>t"] = {
               name = "Terminal",
               f = {"<cmd>ToggleTerm direction=float<CR>", "ToggleTerm Float"},
               h = {"<cmd>ToggleTerm size=10 direction=horizontal<CR>", "ToggleTerm horizontal"},
               v = {"<cmd>ToggleTerm size=80 direction=vertical<CR>", "ToggleTerm vertical"},
            }
         })
   end,
   config = true,
   cond = vim.g.vscode == nil,
}
