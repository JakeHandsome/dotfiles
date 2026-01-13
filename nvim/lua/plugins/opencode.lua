return {
   'NickvanDyke/opencode.nvim',
   dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
      { 'folke/which-key.nvim' },
   },

   enabled = vim.fn.executable('opencode') == 1,

   config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
         -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
      }
      require('which-key').add({ '<leader>o', group = '[O]pencode' })

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set(
         { 'n', 'x' },
         '<leader>oa',
         function() require('opencode').ask('@this: ', { submit = true }) end,
         { desc = 'Ask opencode' }
      )
      vim.keymap.set(
         { 'n', 'x' },
         '<leader>ox',
         function() require('opencode').select() end,
         { desc = 'Execute opencode action…' }
      )
      vim.keymap.set({ 'n', 't' }, '<C-.>', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })

      vim.keymap.set(
         { 'n', 'x' },
         '<leader>or',
         function() return require('opencode').operator('@this ') end,
         { expr = true, desc = 'Add range to opencode' }
      )
      vim.keymap.set(
         'n',
         '<leader>ol',
         function() return require('opencode').operator('@this ') .. '_' end,
         { expr = true, desc = 'Add line to opencode' }
      )
   end,
}
