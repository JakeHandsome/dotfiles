local map = vim.keymap.set
-- next greatest remap ever : asbjornHaland
map('n', '<leader>p', [["_dP]], { desc = 'Send selection to blackhole and paste line' })
map({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank to system keyboard' })
map({ 'n', 'v' }, '<leader>d', [["_d]], { desc = 'Delete to blackhole' })
map('n', '<leader>Y', [["+Y]], { desc = 'Yank line to system keyboard' })

map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move highlighted line' })
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move highlighted line' })

map('n', 'J', 'mzJ`z', { desc = 'Better J (join lines without moving cursor from initial location)' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Move up one screen' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Move down one screen' })
map('n', 'n', 'nzzzv', { desc = 'Move to the next search result while centering the screen' })
map('n', 'N', 'Nzzzv', { desc = 'Move to the last search result while centering the screen' })

-- Disable tab for swithing buffers, must us <C-I> instead
map('n', '<C-I>', '<C-I>', { desc = 'Go to newer cursor position in jump list' })
map('n', '<Tab>', '<Nop>')

-- Toggle between virtual text and lines
map('n', '<leader>ue', function()
   local lines = not vim.diagnostic.config().virtual_lines
   local text = not vim.diagnostic.config().virtual_text
   vim.diagnostic.config({ virtual_lines = lines, virtual_text = text })
end, { desc = 'Toggle multiline diagnostics' })
--
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- better up/down
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window', remap = true })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window', remap = true })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window', remap = true })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window', remap = true })

-- Resize window using <ctrl> arrow keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- Move Lines
map('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
map('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- save file
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- better indenting
map('v', '>', '>gv')
map('v', '<', '<gv')

-- windows
map('n', '<leader>-', '<C-W>s', { desc = 'Split Window Below', remap = true })
map('n', '<leader>|', '<C-W>v', { desc = 'Split Window Right', remap = true })
map('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', remap = true })

map('n', '<leader>uf', function()
   vim.g.autoformat = not vim.g.autoformat
   vim.notify('Auto format: ' .. tostring(vim.g.autoformat), vim.log.levels.INFO, { title = 'Format toggle' })
end, { desc = 'Toggle format on save' })
map('n', '<leader>uw', function()
   vim.o.wrap = not vim.o.wrap
   vim.notify('Wrap: ' .. tostring(vim.o.wrap), vim.log.levels.INFO, { title = 'Wrap toggle' })
end, { desc = 'Toggle word wrap' })
