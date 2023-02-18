return {
   "nvim-telescope/telescope.nvim",
   dependencies = {
      {
         "nvim-telescope/telescope-fzf-native.nvim",
         build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
      {
         "nvim-telescope/telescope-node-modules.nvim",
         keys = {
            { "<leader>fj", "<cmd> Telescope node_modules list<cr>", desc = "node_modules search" },
         },
      },
   },
   -- apply the config and additionally load fzf-native
   config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("node_modules")
   end,
}
