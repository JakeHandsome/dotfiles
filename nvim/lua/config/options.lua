-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.relativenumber = true
vim.opt.conceallevel = 0

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.swapfile = false
vim.opt.backup = false

if vim.loop.os_uname().sysname == "Windows_NT" then
   vim.opt.undodir = os.getenv("UserProfile") .. "/.vim/undodir"
else
   vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end
vim.opt.undofile = true
vim.opt.incsearch = true

if vim.g.vscode == nil then
   vim.opt.termguicolors = true
end

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "120"

vim.opt.guifont = "Iosevka:h11"
-- global status line
vim.opt.laststatus = 3

vim.opt.list = true

vim.opt.listchars = "tab:-->,space:·,eol:¬"

if vim.g.neovide ~= nil then
   vim.g.neovide_hide_mouse_when_typing = true
   vim.g.neovide_cursor_vfx_mode = "pixiedust"
   -- No transparency
   vim.g.neovide_transparency = 1
   vim.g.neovide_scroll_animation_length = 0.13 -- in seconds
end

-- Fold settings
vim.o.foldcolumn = "auto"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[fold: ,foldopen:⌄,foldsep: ,foldclose:›]]
-- status column much similar to vscode
-- vim.o.statuscolumn =
--    -- set Highlight
--     --"%#FoldColumn#"
--    -- Add folds
--     -- .. '%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "⌄ " : "› ") : "  " }'
--    --   fold coumn
--      "%C"
--    -- Right align
--    .. "%="
--    -- Highlight line number
--    .. "%*"
--    -- set relative line numbers
--    .. "%{v:relnum?v:relnum:v:lnum} "
--    -- Add sign column
--    .. "%s"

-- default clipboard settings
vim.opt.clipboard = ""

-- No animations
vim.g.snacks_animate = false
