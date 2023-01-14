return {
    "ktunprasert/gui-font-resize.nvim",
    init = function()
        if vim.g.neovide then
            require("which-key").register({
                ["<C-F12>"] = { "<Cmd>GUIFontSizeUp<CR>", "Font size up" },
                ["<C-F11>"] = { "<Cmd>GUIFontSizeDown<CR>", "Font size down" }
            }
            )
        end
    end,
    config = true,
    cmd = {"GUIFontSizeDown","GUIFontSizeUp"}
}
