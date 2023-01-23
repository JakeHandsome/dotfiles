return {
	"ahmedkhalf/project.nvim",
	event = "VeryLazy",
	keys = {
		{ "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" }
	},
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
