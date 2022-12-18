return {
    "ahmedkhalf/project.nvim",
    config = function()
        require("project_nvim").setup {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            silent_chdr = false,
            require('telescope').load_extension('projects')
        }
    end
}
