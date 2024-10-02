-- Trying devries autocmd tut
vim.api.nvim_create_autocmd('TextYankPost',{
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('darth-highlight-yank', { clear = true }),
    callback = function ()
        vim.highlight.on_yank ()
    end,
})

-- alias
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
--local term_opts = { silent = true }
--local set = vim.opt

-- My settings
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.scrolloff = 5
vim.opt.cursorline = true
vim.opt.incsearch = true
vim.opt.tabstop = 4 -- default=8 , A tab character is 4 spaces
vim.opt.softtabstop=4 -- pressing tab inserts 4 spaces
vim.opt.undofile = true
vim.opt.shiftwidth=4                                        -- useful for shifting (<< | >>)
vim.opt.expandtab = true --spaces for tabs lol
vim.opt.completeopt = { "menu", "menuone", "noselect" }
--vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.relativenumber = true
vim.opt.backspace = {'indent', 'eol', 'start'}

--vim.opt.timeoutlen = 500
-- dont work investigate
--vim.opt.showmode = true
--vim.opt.swapfile = true

-- Leader
map("n", " ", "<Nop>", opts)
vim.g.mapleader=' '

-- save file, custom
map('n', "<A-;>", ':w <CR>', opts)

-- split navigatorrr
-- down
--map('n', "<C-j>", '<C-w>j', opts)

-- up
--map('n', "<C-k>", '<C-w>k', opts)

-- left
--map('n', "<C-h>", '<C-w>h', opts)

-- right
--map('n', "<C-l>", '<C-w>l', opts)

-- quit shortcut
map('n', "<C-u>", ':q <CR>', opts)

-- Set clipboard to use system clipboard
vim.o.clipboard = 'unnamedplus'

--copy/from clipboard
-- map('n', '<leader>y', "+y", opts)
-- map('n', '<leader>Y', "+yg_", opts)

-- paste from clipboard
-- map('n', '<leader>p', "+p", opts)
-- map('n', '<leader>P', "+P", opts)
--vim.api.nvim_set_option("clipboard","unnamed")

-- Navigate buffers
--map("n", "<S-l>", ":bnext<CR>", opts)
--map("n", "<S-h>", ":bprevious<CR>", opts)
--map("n", "<C-'>", ":BufferClose<CR>", opts)
map("n", "<S-h>", ":BufferPrevious<CR>", opts)
map("n", "<S-l>", ":BufferNext<CR>", opts)
--map("n", "<S-A>", ":BufferClose<CR>", opts)
map("n", "c<leader>", ":BufferClose<CR>", opts)
map("n", "C<leader>", ":BufferCloseAllButCurrent<CR>", opts)
--map('n', '<S-'>', '<Cmd>BufferClose<CR>', opts)

-- barbar keybinds
-- Move to previous/next
--map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
--map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)

-- Re-order to previous/next
--map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
--map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

-- Goto buffer in position...
--map('n', '<S-1>', '<Cmd>BufferGoto 1<CR>', opts)
--map('n', '<S-2>', '<Cmd>BufferGoto 2<CR>', opts)
--map('n', '<S-3>', '<Cmd>BufferGoto 3<CR>', opts)
--map('n', '<S-4>', '<Cmd>BufferGoto 4<CR>', opts)
--map('n', '<S-5>', '<Cmd>BufferGoto 5<CR>', opts)
--map('n', '<S-6>', '<Cmd>BufferGoto 6<CR>', opts)
--map('n', '<S-7>', '<Cmd>BufferGoto 7<CR>', opts)
--map('n', '<S-8>', '<Cmd>BufferGoto 8<CR>', opts)
--map('n', '<S-9>', '<Cmd>BufferGoto 9<CR>', opts)
--map('n', '<S-0>', '<Cmd>BufferLast<CR>', opts)

-- Pin/unpin buffer
--map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)

-- Goto pinned/unpinned buffer
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned
-- Close buffer
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map('n', '<A-p>', '<Cmd>BufferPick<CR>', opts)

-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- Tabs
--vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnew<CR>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<leader>tp', ':tabprevious<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>tt', ':tabnext<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>tc', ':tabclose<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>to', ':tabonly<CR>', { noremap = true, silent = true })

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


--new stuff

--[[
-- Using <leader> + number (1, 2, ... 9) to switch tab
for i=1,9,1
do
  map('n', '<leader>'..i, i.."gt", {})
end
]]

--map('n', '<leader>0', ":tablast<cr>", {})

-- map for quick open the file init.lua
--map('n', '<leader>nv', ':vsplit ~/.config/nvim/init.lua<cr>', {})


-- Insert empty line without entering insert mode
map('n', '<A-o>', ':<C-u>call append(line("."), repeat([""], v:count1))<CR>', opts)
map('n', '<A-O>', ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>', opts)

-- Toggle see whitespace characters like: eol, space, ...
--set.lcs = 'tab:>-,eol:$,nbsp:X,trail:#'
--map('n', '<leader>.', ':set list!<cr>')

-- insert
-- Press jk fast to exit insert mode 
--map("i", "jk", "<ESC>", opts)
--map("i", "kj", "<ESC>", opts)

map({ "n", "v" }, "<C-A-j>", "10j", opts)
map({ "n", "v" }, "<C-A-k>", "10k", opts)

-- Move text up and down -- normal mode
--map("n", "<A-j>", ":m .+1<CR>==", opts)
--map("n", "<A-k>", ":m .-2<CR>==", opts)

--map("n", "<S-A-j>", ":m .+1<CR>==", opts)
--map("n", "<S-A-k>", ":m .-2<CR>==", opts)

map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)

--map("n", "<C-Down>", ":m .+1<CR>==", opts)
--map("n", "<C-Up>", ":m .-2<CR>==", opts)

-- go to eol/bol better
map({"v","n"}, "<A-e>", "g_", opts)
map({"v","n"}, "<A-a>", "^", opts)

-- visual
-- Move text up and down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
--map("v", "p", '"_dP', opts)

--visual block
-- Move text up and down
map("x", "J", ":m '>+1<CR>gv=gv", opts)
map("x", "K", ":m '<-2<CR>gv=gv", opts)
map("x", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("x", "<A-k>", ":m '<-2<CR>gv=gv", opts)

--map('n', '<Leader>sv', ':luafile $MYVIMRC<CR>', opts)

-- use U for redo :))
map('n', 'U', '<C-r>', {})

--explorer
-- Map `:Ex` to `<leader>ee`
--vim.api.nvim_set_keymap('n', '<leader>ee', ':Ex<CR>', opts)
map('n', '<leader>l', '<cmd>Lex 40<CR>', opts)
-- Map `:Sexplore 40<cr>` to `<leader>h`
--vim.api.nvim_set_keymap('n', '<leader>h', ':Sexplore 40<CR>', opts)
