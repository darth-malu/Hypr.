    --telescope
return{
    {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config=function()
        --setting up telescope
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})
        vim.keymap.set('n', '<C-j>', builtin.grep_string, {})
        vim.keymap.set('n', '<leader>km', builtin.keymaps, {})
        vim.keymap.set('n', '<C-.>', builtin.lsp_references, {})
        vim.keymap.set('n', '<leader>ps', function()
        builtin.grep_string({search = vim.fn.input("Grep > ")});

end)
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
