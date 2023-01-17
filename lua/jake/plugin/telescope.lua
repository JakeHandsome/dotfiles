return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
    },
    cmd = "Telescope",
    -- Load key binds during init
    init = function()
        require("which-key").register({
            ["<leader>f"] = {
                name = "Find",
                f = { "<Cmd>Telescope find_files<CR>", "Files" },
                g = {
                    name = "Git",
                    b = { "<Cmd>Telescope git_branches<CR>", "Branches" },
                    c = { "<Cmd>Telescope git_commits<CR>", "Commit" },
                    f = { "<Cmd>Telescope git_file<CR>", "Files" },
                    s = { "<Cmd>Telescope git_status<CR>", "Status" }
                },
                p = { "<Cmd>Telescope projects<CR>", "Projects" },
                r = { "<Cmd>Telescope resume<CR>", "Resume" },
                t = { "<Cmd>Telescope<CR>", "Telescope" },
            }
        }
        )
    end,
    config = function()
        -- Add project dependency
        require("project_nvim").setup {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
        require('telescope').load_extension('projects')
    end,
}
