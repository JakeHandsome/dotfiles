-- Set M to an empty table
local M = {}

-- snip

-- Add boolean values to this table
M.isNix = vim.g.nix == true
M.isNotNix = vim.g.nix == nil

-- Add the set function to this table,
-- we can now call it with require("utils").set(a, b)
function M.set(nonNix, nix)
    if M.isNix then
        return nix
    else
        return nonNix
    end
end

-- snip

return M
