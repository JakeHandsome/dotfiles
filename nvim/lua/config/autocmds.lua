-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
local st = vim.lsp.semantic_tokens
vim.api.nvim_create_autocmd("LspTokenUpdate", {
   callback = function(args)
      local token = args.data.token
      if token.modifiers.mutable then
         st.highlight_token(
            token,
            args.buf,
            args.data.client_id,
            "UnderlineMutable",
            { priority = vim.highlight.priorities.semantic_tokens - 1 }
         )
      end
   end,
})

vim.api.nvim_set_hl(0, "UnderlineMutable", { underline = true })
vim.api.nvim_set_hl(0, "@lsp.type.comment.c", { strikethrough = true })
vim.api.nvim_set_hl(0, "@lsp.type.comment.c", { strikethrough = true })
vim.api.nvim_set_hl(0, "@lsp.type.comment.cpp", { strikethrough = true })
