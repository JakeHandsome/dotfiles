return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    init = function()
        require("which-key").register({
            ["<leader>e"] = { "<CMD>Neotree toggle position=left<CR>", "Neotree toggle" },
            ["<leader>pv"] = { "<cmd>NeoTreeFloat<cr>", "Project view" },
        })
    end,
    config = function()
        vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
    end,
    cmd = { "Neotree", "NeoTreeFloat" },
    cond = vim.g.vscode == nil,
}
