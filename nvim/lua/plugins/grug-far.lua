-- Focus existing grug-far window if one is open, otherwise open new
local function focus_or_open(opts)
   local inst = require('grug-far.instances').get_instance()
   if inst and inst:is_open() then
      local win = vim.fn.bufwinid(inst._buf)
      if win ~= -1 then
         vim.api.nvim_set_current_win(win)
         return
      end
   end
   require('grug-far').open(opts)
end

-- Kill any existing grug-far instance, then open with new options
local function replace_or_open(opts)
   local inst = require('grug-far.instances').get_instance()
   if inst then
      inst:close()
   end
   require('grug-far').open(opts)
end

return {
   'MagicDuck/grug-far.nvim',
   cmd = { 'GrugFar', 'GrugFarWithin' },
   opts = { headerMaxWidth = 80 },
   keys = {
      {
         '<leader>go',
         function() focus_or_open({ transient = true }) end,
         mode = { 'n', 'v' },
         desc = '[g]rug-far [o]pen',
      },
      {
         '<leader>gw',
         function()
            replace_or_open({
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
            replace_or_open({
               transient = true,
               prefills = { paths = vim.fn.expand('%') },
            })
         end,
         mode = { 'n', 'v' },
         desc = '[g]rug-far current [f]ile',
      },
   },
}
