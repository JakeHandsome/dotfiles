-- If noice is enabled, let it setup notify
if vim.g.vscode == nil and vim.g.neovide == nil then
   return {}
end

-- Setup notify to work without noice
return {
   "rcarriga/nvim-notify",
   event = "VeryLazy",
   config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
   end
}
