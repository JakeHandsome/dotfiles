-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
local function get_root()
    ---@type string?
    local path = vim.api.nvim_buf_get_name(0)
    path = path ~= "" and vim.loop.fs_realpath(path) or nil
    ---@type string[]
    local roots = {}
    if path then
        for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            local workspace = client.config.workspace_folders
            local paths = workspace and vim.tbl_map(function(ws)
                return vim.uri_to_fname(ws.uri)
            end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
            for _, p in ipairs(paths) do
                local r = vim.loop.fs_realpath(p)
                if path:find(r, 1, true) then
                    roots[#roots + 1] = r
                end
            end
        end
    end
    table.sort(roots, function(a, b)
        return #a > #b
    end)
    ---@type string?
    local root = roots[1]
    if not root then
        path = path and vim.fs.dirname(path) or vim.loop.cwd()
        ---@type string?
        root = vim.fs.find({ ".git", ".lua" }, { path = path, upward = true })[1]
        root = root and vim.fs.dirname(root) or vim.loop.cwd()
    end
    ---@cast root string
    return root
end

-- this will return a function that calls telescope.
-- cwd will defautlt to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
local function telescope_helper(builtin, opts)
    local params = { builtin = builtin, opts = opts }
    return function()
        builtin = params.builtin
        opts = params.opts
        opts = vim.tbl_deep_extend("force", { cwd = get_root() }, opts or {})
        if builtin == "files" then
            if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
                opts.show_untracked = true
                builtin = "git_files"
            else
                builtin = "find_files"
            end
        end
        require("telescope.builtin")[builtin](opts)
    end
end

return {
    {
        'nvim-telescope/telescope.nvim',
        version = false,
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
        cmd = "Telescope",
        keys = {
            { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
            { "<leader>/", telescope_helper("live_grep"), desc = "Find in Files (Grep)" },
            { "<leader>f:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
            -- find
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            { "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Current Buffer" },
            { "<leader>fC", telescope_helper("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
            { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
            { "<leader>ff", telescope_helper("files"), desc = "Find Files (root dir)" },
            { "<leader>fF", telescope_helper("files", { cwd = false }), desc = "Find Files (cwd)" },
            { "<leader>fl", telescope_helper("live_grep"), desc = "Grep (root dir)" },
            { "<leader>fL", telescope_helper("live_grep", { cwd = false }), desc = "Grep (cwd)" },
            { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projets" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
            { "<leader>fw", telescope_helper("grep_string"), desc = "Word (root dir)" },
            { "<leader>fW", telescope_helper("grep_string", { cwd = false }), desc = "Word (cwd)" },
            -- git
            { "<leader>fgc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
            { "<leader>fgs", "<cmd>Telescope git_status<CR>", desc = "status" },
            -- search
            {
                "<leader>fs",
                telescope_helper("lsp_document_symbols", {
                    symbols = {
                        "Class",
                        "Function",
                        "Method",
                        "Constructor",
                        "Interface",
                        "Module",
                        "Struct",
                        "Trait",
                        "Field",
                        "Property",
                    },
                }),
                desc = "Goto Symbol",
            },
        },
        opts = {
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                mappings = {
                    i = {
                        ["<c-t>"] = function(...)
                            return require("trouble.providers.telescope").open_with_trouble(...)
                        end,
                        ["<C-i>"] = function()
                            telescope_helper("find_files", { no_ignore = true })()
                        end,
                        ["<C-h>"] = function()
                            telescope_helper("find_files", { hidden = true })()
                        end,
                        ["<C-Down>"] = function(...)
                            return require("telescope.actions").cycle_history_next(...)
                        end,
                        ["<C-Up>"] = function(...)
                            return require("telescope.actions").cycle_history_prev(...)
                        end,
                    },
                },
            }
        },
    },
    {
            "ahmedkhalf/project.nvim",
        event = "VeryLazy",
        config = function()
            -- Add project dependency
            require("project_nvim").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
            require('telescope').load_extension('projects')
        end
    }
}
