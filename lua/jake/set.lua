vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.relativenumber = true

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
    vim.cmd([[colorscheme codedark]])
    vim.opt.termguicolors = true
end

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "120"

if vim.g.neovide then
    vim.opt.guifont = "Iosevka:h11"
end
-- global status line
vim.opt.laststatus = 3

vim.opt.list = true

vim.opt.listchars="tab:-->,space:·,eol:¬"
