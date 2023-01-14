return {
    "ktunprasert/gui-font-resize.nvim",
    config = function()
        require("gui-font-resize").setup()
        if vim.g.neovide then
            require("which-key").register({
                ["<C-]>"] = { "<Cmd>GUIFontSizeUp<CR>", "Font size up" },
                ["<C-[>"] = { "<Cmd>GUIFontSizeDown<CR>", "Font size down" }
            }
            )
        end
    end,
    cond = vim.g.neovide ~= nil,
}
