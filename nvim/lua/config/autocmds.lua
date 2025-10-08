local st = vim.lsp.semantic_tokens
vim.api.nvim_create_autocmd('LspTokenUpdate', {
   callback = function(args)
      local token = args.data.token
      if token.modifiers.mutable then
         st.highlight_token(
            token,
            args.buf,
            args.data.client_id,
            'UnderlineMutable',
            { priority = vim.highlight.priorities.semantic_tokens - 1 }
         )
      end
   end,
})

vim.api.nvim_set_hl(0, 'UnderlineMutable', { underline = true })
vim.api.nvim_set_hl(0, '@lsp.type.comment.c', { strikethrough = true })
vim.api.nvim_set_hl(0, '@lsp.type.comment.c', { strikethrough = true })
vim.api.nvim_set_hl(0, '@lsp.type.comment.cpp', { strikethrough = true })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
   desc = 'Highlight when yanking (copying) text',
   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
   callback = function() vim.hl.on_yank() end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
   group = vim.api.nvim_create_augroup('jake-checktime', { clear = true }),
   callback = function()
      if vim.o.buftype ~= 'nofile' then
         vim.cmd('checktime')
      end
   end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
   group = vim.api.nvim_create_augroup('jake-resize_splits', { clear = true }),
   callback = function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd('tabdo wincmd =')
      vim.cmd('tabnext ' .. current_tab)
   end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
   group = vim.api.nvim_create_augroup('jake-last_loc', { clear = true }),
   callback = function(event)
      local exclude = { 'gitcommit' }
      local buf = event.buf
      if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
         return
      end
      vim.b[buf].lazyvim_last_loc = true
      local mark = vim.api.nvim_buf_get_mark(buf, '"')
      local lcount = vim.api.nvim_buf_line_count(buf)
      if mark[1] > 0 and mark[1] <= lcount then
         pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
   end,
})

-- Set c/h file to only format modifications
vim.api.nvim_create_autocmd('FileType', {
   group = vim.api.nvim_create_augroup('jake-cformatter', { clear = true }),
   pattern = { 'c', 'cpp' },
   callback = function(event)
      vim.notify('Set buffer to format only modifications', vim.log.levels.DEBUG, { title = 'Debug' })
      vim.b[event.buf].format_modifications_only = true
   end,
})
