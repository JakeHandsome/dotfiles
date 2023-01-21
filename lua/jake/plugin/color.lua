return {
    "NvChad/nvim-colorizer.lua",
    config = true,
    cmd = {"ColorizerAttachToBuffer","ColorizerDetachFromToBuffer","ColorizerToggle"},
    cond = vim.g.vscode == nil,
}
