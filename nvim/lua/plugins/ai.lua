return {
   {
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
         vim.keymap.set(
            { 'n', 't' },
            '<C-.>',
            function() require('opencode').toggle() end,
            { desc = 'Toggle opencode' }
         )

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
   },
   {
      'pablopunk/pi.nvim',
      config = function()
         -- Neovim exposes libuv under `vim.uv` in newer versions.
         -- Older versions used `vim.loop`, so this fallback keeps the config
         -- working across both APIs.
         local uv = vim.uv or vim.loop

         local pi_config_dir = vim.env.PI_CODING_AGENT_DIR

         if not pi_config_dir or pi_config_dir == '' then
            -- No custom directory was provided, so fall back to the default
            -- pi agent location inside the user's home directory:
            --   ~/.pi/agent
            pi_config_dir = vim.fs.joinpath(uv.os_homedir(), '.pi', 'agent')
         else
            -- A custom directory was provided via the environment.
            -- Expand it so values like `~` or other Vim-style path shortcuts
            -- are resolved to a full usable path before we use it.
            pi_config_dir = vim.fn.expand(pi_config_dir)
         end

         -- Store plugin logs in a `tmp` directory inside the pi config dir.
         -- This keeps logs separate from the rest of the config files while
         -- still keeping them under the same main pi directory.
         local log_dir = vim.fs.joinpath(pi_config_dir, 'tmp')

         -- Ensure the log directory actually exists before the plugin tries
         -- to write a log file into it.
         -- The `'p'` flag means "create parent directories as needed",
         -- similar to `mkdir -p` on the command line.
         vim.fn.mkdir(log_dir, 'p')

         -- Initialize `pi.nvim` and tell it exactly where its log file should go.
         -- The final log path will be something like:
         --   ~/.pi/agent/tmp/pi-nvim.log
         -- or the equivalent path inside `PI_CODING_AGENT_DIR` if that env var
         -- was set.
         require('pi').setup({
            log_path = vim.fs.joinpath(log_dir, 'pi-nvim.log'),
         })

         -- Ask pi with the current buffer as context
         vim.keymap.set('n', '<leader>op', ':PiAsk<CR>', { desc = 'Ask pi' })
         -- Ask pi with visual selection as context
         vim.keymap.set('v', '<leader>op', ':PiAskSelection<CR>', { desc = 'Ask pi (selection)' })
      end,
   },
}
