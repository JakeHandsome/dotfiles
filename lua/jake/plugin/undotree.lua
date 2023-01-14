return {
    'mbbill/undotree',
    config = function()
        require("which-key").register(
            { u = { "<cmd>UndotreeToggle<CR>", "UndotreeToggle" } },
            { prefix = "<leader>" })
    end,
}
