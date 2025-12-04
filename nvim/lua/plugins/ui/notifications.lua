return {
   'rcarriga/nvim-notify',
   event = 'VeryLazy',
   opts = {
      stages = 'slide',
      level = vim.log.levels.DEBUG,
   },
   config = function(_, opts)
      require('notify').setup(opts)
      vim.notify = require('notify')
   end,
}
