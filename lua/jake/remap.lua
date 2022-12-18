local wk = require("which-key")

-- Register leader mappings with description
-- Normal mode registrations
wk.register({
    d = "Delete to blackhole",
    p = {
        name = "project",
        v = { "<cmd>Ex<cr>", "View" },
    },
    s = {
        r = { "Search and replace" },
    },
    y = "Yank to system clipboard",
    Y = "Yank line to system clipboard",
}, { prefix = "<leader>" })
-- Visual mode registrations
wk.register({
    y = "Yank to system clipboard",
    d = "Delete to blackhole",
}, { prefix = "<leader>", mode = "v" })

-- X mode
wk.register({
    p = { [["_dP]], "Send selection to blackhole and paste line" }
}, { prefix = "<leader>", mode = "x", })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "<leader>Y", [["+Y]])


vim.keymap.set("n", "<leader>Y", [["+Y]])


vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "kj", "<Esc>")

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
--


vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
