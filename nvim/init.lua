-- Check if nixos
local os_version = vim.loop.os_uname().version
vim.g.NixOs = os_version:match("NixOS") ~= nil

vim.filetype.add({
   extension = { sysarch = "jsonc" },
})
require("config.lazy")
