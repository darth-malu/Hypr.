return{
    {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config=function()
        --setting up telescope
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp'})
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps'})
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles'})
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume'})
        vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers'})
        vim.keymap.set('n', '<leader>z', builtin.current_buffer_fuzzy_find, { desc = 'Current Buffer fuzzy find'})
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing Buffers'})
        --vim.keymap.set('n', '<C-s', builtin.grep_string, {})
        vim.keymap.set('n', '<leader>Z', builtin.grep_string, {})
        --vim.keymap.set('n', '<leader>km', builtin.keymaps, {})
        --vim.keymap.set('n', '<C-.>', builtin.lsp_references, {})
        --vim.keymap.set('n', '<leader>R', builtin.lsp_references, {})

        --vim.keymap.set('n', '<leader>r', builtin.lsp_references, {})

        -- ps function
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({search = vim.fn.input("Grep > ")});
        end)

        -- custom nvim config settings telescope search
        vim.keymap.set('n', '<leader>sn', function ()
            builtin.find_files { cwd = vim.fn.stdpath 'config'}
        end, { desc = '[S]earch [N]eovim files'})
    end
    },

    {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
        require("telescope").setup {
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                    }
                }
            }
        }
    require("telescope").load_extension("ui-select")
    end
    }
}
