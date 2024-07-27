local map = vim.keymap.set
local opts = { noremap = true, silent = true }
--local term_opts = { silent = true }
local defaults = { noremap = true, silent = true }
local set = vim.opt

set.termguicolors = true
set.expandtab = true
set.number = true
set.scrolloff = 5
set.cursorline = true
set.incsearch = true
set.tabstop = 4
set.softtabstop=4
set.swapfile = true
set.shiftwidth=4
set.expandtab = true
--set.autoindent = true
set.relativenumber = true
set.backspace = {'indent', 'eol', 'start'}

--highlight.Error guibg=red
--vim.api.nvim_set_hl(0, 'Error', {guibg = 'red'})
--vim.api.nvim_set_hl(0, 'Warning', {link = 'Error'})
--highlight link Warning Error

--bindings
--vim.o.relativenumber = false --trying comment stuff lol we call these meta-accessors
--vim.api.nvim_set_keymap('i','jk','<ESC>', {noremap=true})

--remap space as leader
--By mapping the space key to "<Nop>", disabling the space key in Normal mode
--reserve for leader
--silent = no messages displayed
--remap mapping will not be recursively mapped (it won't be affected by other mappings of "<Nop>")
map("n", " ", "<Nop>", opts)
vim.g.mapleader=' '
--map('n', '<Leader>sv', ':luafile $MYVIMRC<CR>', opts)
map('n', "<C-;>", ':w <CR>', opts)

--explorer
-- Map `:Ex` to `<leader>ee`
vim.api.nvim_set_keymap('n', '<leader>ee', ':Ex<CR>', opts)
-- Map `:Lex 40<cr>` to `<leader>x`
vim.api.nvim_set_keymap('n', '<leader>x', ':Lex 40<CR>', opts)
-- Map `:Sexplore 40<cr>` to `<leader>h`
vim.api.nvim_set_keymap('n', '<leader>h', ':Sexplore 40<CR>', opts)

-- Function to open a file and close the netrw panel
--[[
local function open_file_and_close_panel()
    -- Save the current window ID
    local current_window = vim.api.nvim_get_current_win()
    -- Open the file (the file will be opened in the current window)
    vim.cmd('normal! <CR>')  -- Simulate pressing Enter to open the file
    -- Close the netrw panel
    vim.api.nvim_set_current_win(current_window)  -- Focus back to the original window
    vim.cmd('bd')  -- Close the buffer (netrw panel)
end
-- Map `:Lex 40<CR>` to `<leader>x` and call the function
vim.api.nvim_set_keymap('n', '<leader>x', ':Lex 40<CR>:lua open_file_and_close_panel()<CR>', opts)
]]--


--copy/from clipboard
map('n', '<leader>y', "+y", opts)
map('n', '<leader>Y', "+yg_", opts)

map('n', '<leader>p', "+p", opts)
map('n', '<leader>P', "+P", opts)
vim.api.nvim_set_option("clipboard","unnamed")

--new stuff

-- Using <leader> + number (1, 2, ... 9) to switch tab
for i=1,9,1
do
  map('n', '<leader>'..i, i.."gt", {})
end
map('n', '<leader>0', ":tablast<cr>", {})

-- map for quick open the file init.lua
map('n', '<leader>nv', ':vsplit ~/.config/nvim/init.lua<cr>', {})

-- use U for redo :))
map('n', 'U', '<C-r>', {})

-- Insert empty line without entering insert mode
map('n', '<A-o>', ':<C-u>call append(line("."), repeat([""], v:count1))<CR>', defaults)
map('n', '<A-O>', ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>', defaults)

-- Toggle see whitespace characters like: eol, space, ...
set.lcs = 'tab:>-,eol:$,nbsp:X,trail:#'
map('n', '<leader>.', ':set list!<cr>')

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down -- normal mode
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)

-- insert
-- Press jk fast to exit insert mode 
map("i", "jk", "<ESC>", opts)
map("i", "kj", "<ESC>", opts)

-- visual
-- Move text up and down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
--map("v", "p", '"_dP', opts)

-- go to eol better
map({"v","n"}, "<C-e>", "g_", opts)
map({"v","n"}, "<C-a>", "^", opts)

--visual block
-- Move text up and down
map("x", "J", ":m '>+1<CR>gv=gv", opts)
map("x", "K", ":m '<-2<CR>gv=gv", opts)
map("x", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("x", "<A-k>", ":m '<-2<CR>gv=gv", opts)
