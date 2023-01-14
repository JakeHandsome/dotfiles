vim.opt.nu = true
vim.opt.signcolumn = 'yes'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.incsearch = true

if vim.g.vscode == nil then
    vim.opt.termguicolors = true
end

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "120"

vim.g.mapleader = " "

if vim.g.neovide then
    vim.opt.guifont = "Iosevka:h12"
end
