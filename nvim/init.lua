local os_version = vim.loop.os_uname().version
vim.g.NixOs = os_version:match("NixOS") ~= nil

require("config.lazy")
