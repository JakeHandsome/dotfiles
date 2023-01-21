local function diagnostic_goto(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

local function lsp_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

return {
    {
        "neovim/nvim-lspconfig",
        cond = vim.g.vscode == nil,
        event = "BufReadPre",
        dependencies = {
            { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
            { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",

        },
        ---@class PluginLspOpts
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = { spacing = 4, prefix = "●" },
                severity_sort = true,
            },
            -- Automatically format on save
            autoformat = true,
            -- options for vim.lsp.buf.format
            -- `bufnr` and `filter` is handled by the LazyVim formatter,
            -- but can be also overriden when specified
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            ---@type lspconfig.options
            servers = {
                jsonls = {},
                sumneko_lua = {
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require("typescript").setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        },
        ---@param opts PluginLspOpts
        config = function(plugin, opts)

            -- setup formatting and keymaps
            lsp_attach(function(client, buffer)
                -- Auto formatting
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = vim.api.nvim_create_augroup("LspFormat." .. buffer, {}),
                        buffer = buffer,
                        callback = function()
                            print("Format on save")
                        end
                    })
                end
                -- Key maps

                vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
                vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
                vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Goto Definition" })
                vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
                vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { desc = "Goto Implementation" })
                vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Goto Type Definition" })
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
                if client.server_capabilities["signatureHelpProvider"] then
                    vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "signature help" })
                    vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, { desc = "signature help" })
                end
                vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
                vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
                vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
                vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
                vim.keymap.set("n", "]w", diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
                vim.keymap.set("n", "[w", diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

                vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format Document" })
                vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { expr = true, desc = "Rename" })
                if client.server_capabilities["documentRangeFormattingProvider"] then
                    vim.keymap.set("v", "<leader>cf", vim.lsp.buf.format, { desc = "Format Range" })
                end
            end)

            -- diagnostics
            for name, icon in pairs(require("jake.icons").diagnostics) do
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
            end
            vim.diagnostic.config(opts.diagnostics)

            local servers = opts.servers
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

            require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
            require("mason-lspconfig").setup_handlers({
                function(server)
                    local server_opts = servers[server] or {}
                    server_opts.capabilities = capabilities
                    if opts.setup[server] then
                        if opts.setup[server](server, server_opts) then
                            return
                        end
                    elseif opts.setup["*"] then
                        if opts.setup["*"](server, server_opts) then
                            return
                        end
                    end
                    require("lspconfig")[server].setup(server_opts)
                end,
            })
        end,
    },
    -- snippets
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end
        },
        opts = {
            history = true,
            delete_check_events = "TextChanged"
        },
        keys = {
            {
                "<tab>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                end,
                expr = true, silent = true, mode = "i"
            },
            { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
            { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        }
    },
    -- Completion
    {
        "hrsh7th/nvim-cmp",
        cond = vim.g.vscode == nil,
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        opts = function()
            local cmp = require("cmp")
            return {
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                formatting = {
                    format = function(_, item)
                        local icons = require("jake.icons").kinds
                        if icons[item.kind] then
                            item.kind = icons[item.kind] .. item.kind
                        end
                        return item
                    end,
                },
                experimental = {
                    ghost_text = {
                        hl_group = "LspCodeLens",
                    },
                },
            }
        end,
    },
    -- Lsp installers
    {
        "williamboman/mason.nvim",
        cond = vim.g.vscode == nil,
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        opts = {
            ensure_installed = {
                "stylua",
                "shellcheck",
                'rust-analyzer',
            },
        },
        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(plugin, opts)
            if plugin.ensure_installed then
                require("lazyvim.util").deprecate("treesitter.ensure_installed", "treesitter.opts.ensure_installed")
            end
            require("mason").setup(opts)
            local mr = require("mason-registry")
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end,
    },

    {
        'lvimuser/lsp-inlayhints.nvim',
        cond = vim.g.vscode == nil,
        lazy = true,
    },
    -- nvim lightbulb
    {
        'kosayoda/nvim-lightbulb',
        opts = { autocmd = { enabled = true } },
        dependencies = 'antoinemadec/FixCursorHold.nvim',
        event = "BufReadPre",
        cond = vim.g.vscode == nil,
    }
}
