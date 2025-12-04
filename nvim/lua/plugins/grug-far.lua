return {
   'MagicDuck/grug-far.nvim',
   cmd = { 'GrugFar', 'GrugFarWithin' },
   opts = { headerMaxWidth = 80 },
   keys = {
      {
         '<leader>go',
         function()
            require('grug-far').open({
               transient = true,
            })
         end,
         mode = { 'n', 'v' },
         desc = '[g]rug-far [o]pen',
      },
      {
         '<leader>gw',
         function()
            require('grug-far').open({
               transient = true,
               prefills = { search = vim.fn.expand('<cword>') },
            })
         end,
         mode = { 'n', 'v' },
         desc = '[g]rug-far search [w]ord',
      },
      {
         '<leader>gf',
         function()
            require('grug-far').open({
               transient = true,
               prefills = { paths = vim.fn.expand('%') },
            })
         end,
         mode = { 'n', 'v' },
         desc = '[g]rug-far current [f]ile',
      },
   },
}
