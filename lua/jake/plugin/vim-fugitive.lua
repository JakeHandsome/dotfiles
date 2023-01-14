return {
    "tpope/vim-fugitive",
    cmd = "Git",
    init = function()
        require("which-key").register({
            ["<leader>"] = {
                g = {
                    name = "Git",
                    s = { vim.cmd.Git, "Status" },
                   ["dt"] = { "<Cmd>Git difftool -d<CR>", "Difftool" }
                },
            }
        })
    end,
    cond = vim.g.vscode == nil,
}
