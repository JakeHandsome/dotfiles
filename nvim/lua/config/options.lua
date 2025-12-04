vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.relativenumber = true
vim.opt.conceallevel = 0

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.showmode = false

vim.opt.swapfile = false
vim.opt.backup = false

if vim.loop.os_uname().sysname == 'Windows_NT' then
   vim.opt.undodir = os.getenv('UserProfile') .. '/.vim/undodir'
else
   vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
end
vim.opt.undofile = true
vim.opt.incsearch = true

if vim.g.vscode == nil then
   vim.opt.termguicolors = true
end
-- Enable break indent
vim.o.breakindent = true
vim.o.wrap = false

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')

vim.opt.updatetime = 50
vim.opt.colorcolumn = '120'

vim.opt.guifont = 'Iosevka:h11'
-- global status line
vim.opt.laststatus = 3

vim.opt.list = true

vim.opt.listchars = { tab = '-->', nbsp = '␣', eol = '¬', space = '·' }

if vim.g.neovide ~= nil then
   vim.g.neovide_hide_mouse_when_typing = true
   vim.g.neovide_cursor_vfx_mode = 'pixiedust'
   -- No transparency
   vim.g.neovide_transparency = 1
   vim.g.neovide_scroll_animation_length = 0.13 -- in seconds
end

-- Fold settings
vim.o.foldcolumn = 'auto'
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
vim.opt.clipboard = ''

-- No animations
vim.g.snacks_animate = false

-- Rounded popup windows
vim.opt.winborder = 'rounded'

vim.diagnostic.config({ virtual_lines = false, virtual_text = true })

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true
-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'
-- Show which line your cursor is on
vim.o.cursorline = true
-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true
