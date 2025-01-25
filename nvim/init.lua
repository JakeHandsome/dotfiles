-- Check if nixos
local os_version = vim.loop.os_uname().version
vim.g.NixOs = os_version:match("NixOS") ~= nil

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
