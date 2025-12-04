local function format_hunks(bufnr)
   local ignore_filetypes = { 'lua' }
   if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
      vim.notify('range formatting for ' .. vim.bo.filetype .. ' not working properly.')
      return
   end

   local hunks = require('gitsigns').get_hunks(bufnr)
   if hunks == nil then
      return
   end

   local format = require('conform').format

   local function format_range()
      if next(hunks) == nil then
         vim.notify('done formatting git hunks', 'info', { title = 'formatting' })
         return
      end
      local hunk = nil
      while next(hunks) ~= nil and (hunk == nil or hunk.type == 'delete') do
         hunk = table.remove(hunks)
      end

      if hunk ~= nil and hunk.type ~= 'delete' then
         local start = hunk.added.start
         local last = start + hunk.added.count
         -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
         local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
         local range = { start = { start, 0 }, ['end'] = { last - 1, last_hunk_line:len() } }
         format({ range = range, async = true, lsp_fallback = true }, function()
            vim.defer_fn(function() format_range() end, 1)
         end)
      end
   end

   format_range()
end

return { -- Autoformat
   'stevearc/conform.nvim',
   dependencies = { 'lewis6991/gitsigns.nvim' },
   event = { 'BufWritePre' },
   cmd = { 'ConformInfo' },
   init = function()
      vim.g.autoformat = true
      vim.g.format_modifications_only = false
   end,
   opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
         local default_format_options = {
            timeout_ms = 500,
            lsp_format = 'fallback',
         }
         if vim.g.autoformat == false then
            return
         end
         if vim.g.format_modifications_only or vim.b[bufnr].format_modifications_only then
            format_hunks(bufnr)
         else
            return default_format_options
         end
      end,
      formatters_by_ft = {
         lua = { 'stylua' },
         -- Conform can also run multiple formatters sequentially
         -- python = { "isort", "black" },
         --
         -- You can use 'stop_after_first' to run the first available formatter from the list
         -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
   },
}
