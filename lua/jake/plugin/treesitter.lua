return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = "BufReadPost",
        keys = {
            { "<bs>", desc = "Schrink selection", mode = "x" },
            { "<c-space>", desc = "Increment selection" },
        },
        opts = {
            -- A list of parser names, or "all"
            ensure_installed = {
                "help",
                "c",
                "lua",
                "rust",
                "markdown",
                "markdown_inline",
                "html",
                "json",
                "vim",
                "toml",
                "regex",
            },
            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,
            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,
            highlight = { enable = true, },
            indent = { enable = true },
            context_commentstring = { enable = true, enable_autocmd = false },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = "<nop>",
                    node_decremental = "<bs>",
                },
            },

        },
        cond = vim.g.vscode == nil,
    },
}
