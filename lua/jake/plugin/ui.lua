-- ui related plugins
return {
   -- Popup notifications
   {
      "rcarriga/nvim-notify",
      keys = {
         {
            "<leader>un",
            function()
               require("notify").dismiss({ silent = true, pending = true })
            end,
            desc = "Delete all Notifications",
         },
      },
      opts = {
         timeout = 3000,
         max_height = function()
            return math.floor(vim.o.lines * 0.75)
         end,
         max_width = function()
            return math.floor(vim.o.columns * 0.75)
         end,
      },
      cond = vim.g.vscode == nil,
   },
   -- ui stuff
   {
      "stevearc/dressing.nvim",
      lazy = true,
      init = function()
         ---@diagnostic disable-next-line: duplicate-set-field
         vim.ui.select = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.select(...)
         end
         ---@diagnostic disable-next-line: duplicate-set-field
         vim.ui.input = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.input(...)
         end
      end,
      cond = vim.g.vscode == nil,
   },
   -- lualine for status line
   {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      opts = function(_)
         -- TODO define icons sometime local icons = require("lazyvim.config").icons

         local function fg(name)
            return function()
               ---@type {foreground?:number}?
               local hl = vim.api.nvim_get_hl_by_name(name, true)
               return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
            end
         end

         return {
            options = {
               theme = "auto",
               globalstatus = true,
               disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
            },
            sections = {
               lualine_a = { "mode" },
               lualine_b = { "branch" },
               lualine_c = {
                  {
                     "diagnostics",
                     symbols = {
                        -- TODO icons
                        -- error = icons.diagnostics.Error,
                        -- warn = icons.diagnostics.Warn,
                        -- info = icons.diagnostics.Info,
                        -- hint = icons.diagnostics.Hint,
                     },
                  },
                  { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                  { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
                  -- stylua: ignore
                  {
                     function() return require("nvim-navic").get_location() end,
                     cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
                  },
               },
               lualine_x = {
                  -- stylua: ignore
                  {
                     function() return require("noice").api.status.command.get() end,
                     cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                     color = fg("Statement")
                  },
                  -- stylua: ignore
                  {
                     function() return require("noice").api.status.mode.get() end,
                     cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                     color = fg("Constant"),
                  },
                  { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
                  {
                     "diff",
                     symbols = {
                        -- TODO icons
                        -- added = icons.git.added,
                        -- modified = icons.git.modified,
                        -- removed = icons.git.removed,
                     },
                  },
               },
               lualine_y = {
                  { "progress", separator = "", padding = { left = 1, right = 0 } },
                  { "location", padding = { left = 0, right = 1 } },
               },
               lualine_z = {
                  function()
                     return " " .. os.date("%R")
                  end,
               },
            },
            extensions = { "nvim-tree" },
         }
      end,
   },
   -- noicer ui
   {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = {
         lsp = {
            override = {
               ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
               ["vim.lsp.util.stylize_markdown"] = true,
            },
         },
         presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
         },
      },
      -- stylua: ignore
      keys = {
         { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c",
            desc = "Redirect Cmdline" },
         { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
         { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
         { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
         { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true,
            expr = true, desc = "Scroll forward" },
         { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,
            expr = true, desc = "Scroll backward" },
      },
      cond = vim.g.vscode == nil and vim.g.neovide == nil,
   },

   -- lsp symbol navigation for lualine
   {
      "SmiteshP/nvim-navic",
      lazy = true,
      init = function()
         vim.g.navic_silence = true
         local on_attach = function(client, buffer)
            if client.server_capabilities.documentSymbolProvider then
               require("nvim-navic").attach(client, buffer)
            end
         end
         vim.api.nvim_create_autocmd("lspattach", {
            callback = function(args)
               local buffer = args.buf
               local client = vim.lsp.get_client_by_id(args.data.client_id)
               on_attach(client, buffer)
            end,
         })

      end,
      opts = { separator = " ", highlight = true, depth_limit = 5 },
      cond = vim.g.vscode == nil,
   },

   -- icons
   { "nvim-tree/nvim-web-devicons", lazy = true },

   -- ui components
   { "MunifTanjim/nui.nvim", lazy = true },
}
