return {
    "folke/which-key.nvim",
    opts = { plugins = { spelling = true } },
    event = "VeryLazy",
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.register({
            mode = { "n", "v" },
            ["<leader>f"] = { name = "+find" },
            ["<leader>g"] = { name = "+git" },
            ["<leader>gh"] = { name = "+gitsigns"},
        })
    end,
    lazy = true
}
