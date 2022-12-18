return {
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        },
        config = function()
            local lsp = require('lsp-zero')
            lsp.preset('recommended')


            lsp.ensure_installed({
                'sumneko_lua',
                'rust_analyzer',
            })

            -- Fix Undefined global 'vim'
            lsp.configure('sumneko_lua', {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            })

            lsp.set_preferences({
                suggest_lsp_servers = true,
                sign_icons = {
                    error = 'E',
                    warn = 'W',
                    hint = 'H',
                    info = 'I'
                }
            })

            lsp.on_attach(function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }
                local wk = require("which-key")

                wk.register({
                    ["<leader>"] = {
                        f = { vim.lsp.buf.format, "LSP format" },
                        l = {
                            name = "lsp",
                            c = { vim.lsp.buf.code_action, "Code actions" },
                            r = { vim.lsp.buf.references, "References" },
                            d = { vim.diagnostic.open_float, "Diagnostics" },
                            s = { vim.lsp.buf.workspace_symbol, "Symbols" },
                        }
                    },
                    ["gd"] = { vim.lsp.buf.definition, "LSP Jump to definition" },
                    K = { vim.lsp.buf.hover, "LSP hover" },
                    ["[d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
                    ["]d"] = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
                }, { buffer = bufnr })

                wk.register(
                    { ["<C-h>"] = { vim.lsp.buf.signature_help, "Help" } },
                    { mode = "i", buffer = bufnr }
                )

                -- enable inlay hints for this buffer
                require("lsp-inlayhints").on_attach(client, bufnr)
            end)

            lsp.setup()

            vim.diagnostic.config({
                virtual_text = true,
            })

        end
    },
    {
        'lvimuser/lsp-inlayhints.nvim',
        config = function()
            -- Setup lsp inlay hints same as vscode
            require("lsp-inlayhints").setup()
            vim.cmd [[hi LspInlayHint guifg=#d8d8d8 guibg=#3a3a3a]]

        end
    }

}
