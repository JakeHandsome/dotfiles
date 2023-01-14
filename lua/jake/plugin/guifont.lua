return {
    "ktunprasert/gui-font-resize.nvim",
    init = function()
        if vim.g.neovide then
            require("which-key").register({
                ["<C-]>"] = { "<Cmd>GUIFontSizeUp<CR>", "Font size up" },
                ["<C-[>"] = { "<Cmd>GUIFontSizeDown<CR>", "Font size down" }
            }
            )
        end
    end,
    config = function()
        require("gui-font-resize").setup()
    end,
    cmd = {"GUIFontSizeDown","GUIFontSizeUp"}
}
