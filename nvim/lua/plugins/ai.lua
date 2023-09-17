return {
   {
      "Exafunction/codeium.vim",
      event = "BufEnter",
      cond = function()
         local enabled = tonumber(vim.env.USE_AI_TOOLS) == 1
         if enabled then
            print("Codeium enabled")
         end
         return enabled
      end,
      config = function()
         -- Change '<C-g>' here to any keycode you like.
         vim.keymap.set("i", "<F2>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      end,
   },
}
