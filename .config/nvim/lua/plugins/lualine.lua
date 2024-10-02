return{
    'nvim-lualine/lualine.nvim',
    event = "ColorScheme",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        local colors = {
          blue   = '#80a0ff',
          cyan   = '#79dac8',
          black  = '#080808',
          white  = '#c6c6c6',
          red    = '#ff5189',
          violet = '#d183e8',
          grey   = '#303030',
          --darth_ocean = '#EFF8E2',
          darth_ocean = '#C1E0F7',
          darth_green = '#9BC53D',
          darth_blue = '#00B4D8',
          darth_yellow = '#E6AF2E',
          clear_coean = '#C1E0F740',
          rosepined = '#26233A',
          turqoise = '#2DE1C2',
        }

        local bubbles_theme = {
          normal = {
            a = { fg = colors.black, bg = colors.darth_blue, gui = 'bold' },
            b = { fg = colors.white, bg = colors.rosepined },
            c = { fg = colors.white },
          },

          insert = { a = { fg = colors.black, bg = colors.darth_yellow } },
          visual = { a = { fg = colors.black, bg = colors.turqoise } },
          replace = { a = { fg = colors.black, bg = colors.red } },

          inactive = {
            a = { fg = colors.white, bg = colors.black },
            b = { fg = colors.white, bg = colors.black },
            c = { fg = colors.white },
          },
        }

        require('lualine').setup({
            --options = { theme = 'everforest' } --gruvbox --rose-pine
            options = {
                --theme = 'material',
                theme = bubbles_theme,
                --theme = 'rose-pine',
                --theme = 'gruvbox',
                component_separators = '|',
                section_separators = { left = '', right = '' },
            },
            sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
    lualine_b = { 'filename', 'branch' },
    lualine_c = {
      '%=', --[[ add your center compoentnts here in place of this comment ]] --componktjskjtls lul
    },
    lualine_x = {},
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
            --options = { theme = 'rose-pine' }
        })
    end
}
