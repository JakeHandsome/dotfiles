return {
    "tpope/vim-fugitive",
    cmd = "Git",
    init = function()
        require("which-key").register({
            ["<leader>"] = {
                g = {
                    name = "Git",
                    s = { "<Cmd>tab Git<CR>", "Status" },
                    c = { "<Cmd>tab Git commit<CR>", "commit" },
                   ["dt"] = { "<Cmd>Git difftool -d<CR>", "Difftool" }
                },
            }
        })
    end,
    cond = vim.g.vscode == nil,
}
