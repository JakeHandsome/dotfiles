return {
    "simrat39/rust-tools.nvim",
    ft = { "rs", "toml" },
    -- disably inlay hints because lsp-inlayhint.nvim handles them
    opts = { tools = { inlay_hints = { auto = false } } },
    enabled = false
}
