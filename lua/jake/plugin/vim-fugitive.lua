return {
   "tpope/vim-fugitive",
   config = function() 
      require("which-key").register({
         ["<leader>"] = {
            g = {
               name = "Git",
               s = {vim.cmd.Git,"Status"}
            }
         }
      })
   end,
   cond = vim.g.vscode == nil
}
