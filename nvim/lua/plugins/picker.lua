return {
   {
      'folke/snacks.nvim',
      ---@type snacks.Config
      opts = {
         picker = {},
      },
      keys = {
         -- Top Pickers & Explorer
         { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
         { '<leader>n', function() Snacks.picker.notifications() end, desc = 'Notification History' },
         -- find
         { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
         {
            '<leader>fc',
            function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end,
            desc = 'Find Config File',
         },
         { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files' },
         { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
         { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects' },
         { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },
         -- search
         { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers' },
         { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History' },
         { '<leader>sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },
         { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
         { '<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History' },
         { '<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands' },
         { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
         { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
         { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Pages' },
         { '<leader>sH', function() Snacks.picker.highlights() end, desc = 'Highlights' },
         { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons' },
         { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
         { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
         { '<leader>sl', function() Snacks.picker.loclist() end, desc = 'Location List' },
         { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks' },
         { '<leader>sM', function() Snacks.picker.man() end, desc = 'Man Pages' },
         { '<leader>sp', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec' },
         { '<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
         { '<leader>sR', function() Snacks.picker.resume() end, desc = 'Resume' },
         { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo History' },
         { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
         -- LSP
         { 'grd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
         { 'grD', function() Snacks.picker.lsp_declarations() end, desc = 'Goto Declaration' },
         { 'grr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
         { 'gri', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation' },
         { 'grt', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition' },
         { 'gO', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols' },
         { 'gW', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols' },
      },
   },
   --{ -- Fuzzy Finder (files, lsp, etc)
   --   'nvim-telescope/telescope.nvim',
   --   event = 'VimEnter',
   --   dependencies = {
   --      'nvim-lua/plenary.nvim',
   --      {
   --         'nvim-telescope/telescope-fzf-native.nvim',
   --         build = 'make',
   --         cond = function() return vim.fn.executable('make') == 1 end,
   --      },
   --      { 'nvim-telescope/telescope-ui-select.nvim' },
   --      { 'nvim-tree/nvim-web-devicons' },
   --   },
   --   config = function()
   --      -- Telescope is a fuzzy finder that comes with a lot of different things that
   --      -- it can fuzzy find! It's more than just a "file finder", it can search
   --      -- many different aspects of Neovim, your workspace, LSP, and more!
   --      --
   --      -- The easiest way to use Telescope, is to start by doing something like:
   --      --  :Telescope help_tags
   --      --
   --      -- After running this command, a window will open up and you're able to
   --      -- type in the prompt window. You'll see a list of `help_tags` options and
   --      -- a corresponding preview of the help.
   --      --
   --      -- Two important keymaps to use while in Telescope are:
   --      --  - Insert mode: <c-/>
   --      --  - Normal mode: ?
   --      --
   --      -- This opens a window that shows you all of the keymaps for the current
   --      -- Telescope picker. This is really useful to discover what Telescope can
   --      -- do as well as how to actually do it!

   --      -- [[ Configure Telescope ]]
   --      -- See `:help telescope` and `:help telescope.setup()`
   --      require('telescope').setup({
   --         -- You can put your default mappings / updates / etc. in here
   --         --  All the info you're looking for is in `:help telescope.setup()`
   --         --
   --         -- defaults = {
   --         --   mappings = {
   --         --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
   --         --   },
   --         -- },
   --         -- pickers = {}
   --         extensions = {
   --            ['ui-select'] = {
   --               require('telescope.themes').get_dropdown(),
   --            },
   --         },
   --      })

   --      -- Enable Telescope extensions if they are installed
   --      pcall(require('telescope').load_extension, 'fzf')
   --      pcall(require('telescope').load_extension, 'ui-select')

   --      -- See `:help telescope.builtin`
   --      local builtin = require('telescope.builtin')
   --      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
   --      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
   --      vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = '[S]earch Files' })
   --      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
   --      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
   --      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
   --      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
   --      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
   --      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[ ] Find existing buffers' })
   --   end,
   --},
}
