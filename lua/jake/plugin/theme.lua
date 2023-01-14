return {
    'Mofiqul/vscode.nvim',
    name = 'vscode-style',
    lazy = false, -- cannot lazy load main colorscheme
    priority = 1000, -- Load before all other plugins
    config = function()
        -- Lua:
        -- For dark theme (neovim's default)
        vim.o.background = 'dark'
        -- For light theme
        -- vim.o.background = 'light'

        local c = require('vscode.colors')
        require('vscode').setup({
            -- Enable transparent background
            transparent = true,

            -- Enable italic comment
            italic_comments = true,

            -- Disable nvim-tree background color
            disable_nvimtree_bg = true,

            -- Override highlight groups (see ./lua/vscode/theme.lua)
            group_overrides = {
                -- this supports the same val table as vim.api.nvim_set_hl
                -- use colors from this colorscheme by requiring vscode.colors!
                Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
            }
        })
    end,
    cond = vim.g.vscode == nil
}
