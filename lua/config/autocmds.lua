-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- LspSemanticTokens
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

-- LspInlayHints
vim.api.nvim_create_autocmd("LspAttach", {
   callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.server_capabilities.inlayHintProvider then
         vim.lsp.buf.inlay_hint(bufnr, true)
      end
   end,
})
