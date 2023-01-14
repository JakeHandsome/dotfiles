local wk = require("which-key")

-- Register leader mappings with description
-- Normal mode registrations
wk.register({
    p = {
        name = "project",
        v = { "<cmd>Ex<cr>", "View" },
    },
}, { prefix = "<leader>" })

-- X mode
wk.register({
    p = { [["_dP]], "Send selection to blackhole and paste line" }
}, { prefix = "<leader>", mode = "x", })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]],{desc = "Yank to system keyboard"})
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]],{desc = "Delete to blackhole"})
vim.keymap.set("n", "<leader>Y", [["+Y]], {desc = "Yank line to system keyboard"})


vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "kj", "<Esc>")

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Move highlighted line"})
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move highlighted line"})

vim.keymap.set("n", "J", "mzJ`z",{desc = "J"})
vim.keymap.set("n", "<C-d>", "<C-d>zz",{desc="Move up one screen"})
vim.keymap.set("n", "<C-u>", "<C-u>zz",{desc="Move down one screen"})
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
--


vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],{desc = "Search and replace"})

vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
