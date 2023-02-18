-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>p", [["_dP]], { desc = "Send selection to blackhole and paste line" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system keyboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to blackhole" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system keyboard" })

vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "kj", "<Esc>")

-- Exit terminal mode
vim.keymap.set("t", "jk", "<C-\\><C-n>")
vim.keymap.set("t", "kj", "<C-\\><C-n>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move highlighted line" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move highlighted line" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "J" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move up one screen" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move down one screen" })
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
--
vim.keymap.set(
   "n",
   "<leader>sr",
   [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
   { desc = "Search and replace" }
)
