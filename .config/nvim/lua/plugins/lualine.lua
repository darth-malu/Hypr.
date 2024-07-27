return{
    'nvim-lualine/lualine.nvim',
    event = "ColorScheme",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        require('lualine').setup({
            --options = { theme = 'everforest' } --gruvbox --rose-pine
            options = { theme = 'gruvbox' }
            --options = { theme = 'rosepine' }
        })
    end
}
