-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>p", [["_dP]], { desc = "Send selection to blackhole and paste line" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system keyboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to blackhole" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system keyboard" })

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move highlighted line" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move highlighted line" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Better J (join lines without moving cursor from initial location)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move up one screen" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move down one screen" })
vim.keymap.set("n", "n", "nzzzv", {desc = "Move to the next search result while centering the screen"})
vim.keymap.set("n", "N", "Nzzzv", {desc = "Move to the last search result while centering the screen"})

-- Disable tab for swithing buffers, must us <C-I> instead
vim.keymap.set("n", "<C-I>", "<C-I>", { desc = "Go to newer cursor position in jump list" })
vim.keymap.set("n", "<Tab>", "<Nop>")
