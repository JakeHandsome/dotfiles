---- Default inlay_hints to true
-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
   { import = 'plugins.lang' },
   { import = 'plugins.ui' },
   { -- Adds git related signs to the gutter, as well as utilities for managing changes
      'lewis6991/gitsigns.nvim',
   },

   { -- Useful plugin to show you pending keybinds.
      'folke/which-key.nvim',
      event = 'VimEnter', -- Sets the loading event to 'VimEnter'
      opts = {
         -- delay between pressing a key and opening which-key (milliseconds)
         -- this setting is independent of vim.o.timeoutlen
         delay = 0,
         icons = {
            -- set icon mappings to true if you have a Nerd Font
            mappings = true,
            -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
            -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
            keys = {},
         },

         -- Document existing key chains
         spec = {
            { '<leader>s', group = '[S]earch' },
            { '<leader>t', group = '[T]oggle' },
            { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
            { '<leader>u', group = '[U]I' },
         },
      },
   },

   { -- Fuzzy Finder (files, lsp, etc)
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',
      dependencies = {
         'nvim-lua/plenary.nvim',
         {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function() return vim.fn.executable('make') == 1 end,
         },
         { 'nvim-telescope/telescope-ui-select.nvim' },
         { 'nvim-tree/nvim-web-devicons' },
      },
      config = function()
         -- Telescope is a fuzzy finder that comes with a lot of different things that
         -- it can fuzzy find! It's more than just a "file finder", it can search
         -- many different aspects of Neovim, your workspace, LSP, and more!
         --
         -- The easiest way to use Telescope, is to start by doing something like:
         --  :Telescope help_tags
         --
         -- After running this command, a window will open up and you're able to
         -- type in the prompt window. You'll see a list of `help_tags` options and
         -- a corresponding preview of the help.
         --
         -- Two important keymaps to use while in Telescope are:
         --  - Insert mode: <c-/>
         --  - Normal mode: ?
         --
         -- This opens a window that shows you all of the keymaps for the current
         -- Telescope picker. This is really useful to discover what Telescope can
         -- do as well as how to actually do it!

         -- [[ Configure Telescope ]]
         -- See `:help telescope` and `:help telescope.setup()`
         require('telescope').setup({
            -- You can put your default mappings / updates / etc. in here
            --  All the info you're looking for is in `:help telescope.setup()`
            --
            -- defaults = {
            --   mappings = {
            --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
            --   },
            -- },
            -- pickers = {}
            extensions = {
               ['ui-select'] = {
                  require('telescope.themes').get_dropdown(),
               },
            },
         })

         -- Enable Telescope extensions if they are installed
         pcall(require('telescope').load_extension, 'fzf')
         pcall(require('telescope').load_extension, 'ui-select')

         -- See `:help telescope.builtin`
         local builtin = require('telescope.builtin')
         vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
         vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
         vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
         vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
         vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
         vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
         vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
         vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
         vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
         vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

         -- Slightly advanced example of overriding default behavior and theme
         vim.keymap.set('n', '<leader>/', function()
            -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
               winblend = 10,
               previewer = false,
            }))
         end, { desc = '[/] Fuzzily search in current buffer' })

         -- It's also possible to pass additional configuration options.
         --  See `:help telescope.builtin.live_grep()` for information about particular keys
         vim.keymap.set(
            'n',
            '<leader>s/',
            function()
               builtin.live_grep({
                  grep_open_files = true,
                  prompt_title = 'Live Grep in Open Files',
               })
            end,
            { desc = '[S]earch [/] in Open Files' }
         )

         -- Shortcut for searching your Neovim configuration files
         vim.keymap.set(
            'n',
            '<leader>sn',
            function() builtin.find_files({ cwd = vim.fn.stdpath('config') }) end,
            { desc = '[S]earch [N]eovim files' }
         )
      end,
   },

   -- LSP Plugins
   {
      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
         library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
         },
      },
   },

   { -- Autocompletion
      'saghen/blink.cmp',
      event = 'VimEnter',
      version = '1.*',
      dependencies = {
         -- Snippet Engine
         {
            'L3MON4D3/LuaSnip',
            version = '2.*',
            build = (function()
               -- Build Step is needed for regex support in snippets.
               -- This step is not supported in many windows environments.
               -- Remove the below condition to re-enable on windows.
               if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
                  return
               end
               return 'make install_jsregexp'
            end)(),
            dependencies = {
               -- `friendly-snippets` contains a variety of premade snippets.
               --    See the README about individual language/framework/plugin snippets:
               --    https://github.com/rafamadriz/friendly-snippets
               {
                  'rafamadriz/friendly-snippets',
                  config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
               },
            },
            opts = {},
         },
         'folke/lazydev.nvim',
      },
      --- @module 'blink.cmp'
      --- @type blink.cmp.Config
      opts = {
         keymap = {
            -- 'default' (recommended) for mappings similar to built-in completions
            --   <c-y> to accept ([y]es) the completion.
            --    This will auto-import if your LSP supports it.
            --    This will expand snippets if the LSP sent a snippet.
            -- 'super-tab' for tab to accept
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- For an understanding of why the 'default' preset is recommended,
            -- you will need to read `:help ins-completion`
            --
            -- No, but seriously. Please read `:help ins-completion`, it is really good!
            --
            -- All presets have the following mappings:
            -- <tab>/<s-tab>: move to right/left of your snippet expansion
            -- <c-space>: Open menu or open docs if already open
            -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
            -- <c-e>: Hide menu
            -- <c-k>: Toggle signature help
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            preset = 'default',

            -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
            --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
         },

         appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono',
         },

         completion = {
            -- By default, you may press `<c-space>` to show the documentation.
            -- Optionally, set `auto_show = true` to show the documentation after a delay.
            documentation = { auto_show = false, auto_show_delay_ms = 500 },
         },

         sources = {
            default = { 'lsp', 'path', 'snippets', 'lazydev' },
            providers = {
               lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
            },
         },

         snippets = { preset = 'luasnip' },

         -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
         -- which automatically downloads a prebuilt binary when enabled.
         --
         -- By default, we use the Lua implementation instead, but you may enable
         -- the rust implementation via `'prefer_rust_with_warning'`
         --
         -- See :h blink-cmp-config-fuzzy for more information
         fuzzy = { implementation = 'lua' },

         -- Shows a signature help window while you type arguments for a function
         signature = { enabled = true },
      },
   },
   {
      'nvim-tree/nvim-tree.lua',
      version = '*',
      lazy = false,
      dependencies = {
         'nvim-tree/nvim-web-devicons',
      },
      config = function()
         require('nvim-tree').setup({})
         local api = require('nvim-tree.api')
         vim.keymap.set('n', '<leader>e', function() api.tree.toggle() end, { desc = 'Toggle Tree' })
      end,
   },
   -- Highlight todo, notes, etc in comments
   {
      'folke/todo-comments.nvim',
      event = 'VimEnter',
      dependencies = { 'nvim-lua/plenary.nvim' },
      opts = { signs = false },
   },

   { -- Collection of various small independent plugins/modules
      'nvim-mini/mini.nvim',
      config = function()
         -- Better Around/Inside textobjects
         --
         -- Examples:
         --  - va)  - [V]isually select [A]round [)]paren
         --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
         --  - ci'  - [C]hange [I]nside [']quote
         require('mini.ai').setup({ n_lines = 500 })

         -- Add/delete/replace surroundings (brackets, quotes, etc.)
         --
         -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
         -- - sd'   - [S]urround [D]elete [']quotes
         -- - sr)'  - [S]urround [R]eplace [)] [']
         require('mini.surround').setup()

         -- Simple and easy statusline.
         --  You could remove this setup call if you don't like it,
         --  and try some other statusline plugin
         local statusline = require('mini.statusline')
         -- set use_icons to true if you have a Nerd Font
         statusline.setup({ use_icons = true })

         -- You can configure sections in the statusline by overriding their
         -- default behavior. For example, here we set the section for
         -- cursor location to LINE:COLUMN
         ---@diagnostic disable-next-line: duplicate-set-field
         statusline.section_location = function() return '%2l:%-2v' end

         -- ... and there is more!
         --  Check out: https://github.com/echasnovski/mini.nvim
      end,
   },
   { -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      main = 'nvim-treesitter.configs', -- Sets main module to use for opts
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      opts = {
         ensure_installed = {
            'bash',
            'c',
            'diff',
            'html',
            'lua',
            'luadoc',
            'markdown',
            'markdown_inline',
            'query',
            'vim',
            'vimdoc',
            'rust',
            'toml',
            'nix',
            'groovy',
            'bash',
            'diff',
            'git_config',
            'git_rebase',
            'gitattributes',
            'gitignore',
            'jsdoc',
            'json',
            'json5',
            'jsonc',
            'xml',
            'yaml',
            'regex',
            'printf',
            'python',
         },
         -- Autoinstall languages that are not installed
         auto_install = true,
         highlight = {
            enable = true,
            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            --  If you are experiencing weird indenting issues, add the language to
            --  the list of additional_vim_regex_highlighting and disabled languages for indent.
            additional_vim_regex_highlighting = { 'ruby' },
         },
         indent = { enable = true, disable = { 'ruby' } },
      },
      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
   },
}
