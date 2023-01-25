return {
   "nvim-telescope/telescope.nvim",
   dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim",
         build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
   },
   -- apply the config and additionally load fzf-native
   config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
   end,
}
