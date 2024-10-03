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

        local function greet()
          --return [[To Rice or Not to Rice]]
          return [[Days without ricing: 0]]
        end

        require('lualine').setup({
            --options = { theme = 'everforest' } --gruvbox --rose-pine
            options = {
                --theme = 'material',
                theme = bubbles_theme,
                --theme = 'rose-pine',
                --theme = 'gruvbox',
                --component_separators = '|',
                component_separators = '',
                --section_separators = { left = '', right = '' },
                globalstatus = true
                --component_separators = { left = '', right = ''},
            },

            sections = {
                lualine_a = {
                    { 'mode', separator = { left = '' }, right_padding = 2 },
                    {'diff'},
                },

                lualine_b = {
                    {greet},
                    --[[
                    {
                      'filename',
                      file_status = true,      -- Displays file status (readonly status, modified status)
                      newfile_status = false,  -- Display new file status (new file means no write after created)
                      path = 0,                -- 0: Just the filename
                                               -- 1: Relative path
                                               -- 2: Absolute path
                                               -- 3: Absolute path, with tilde as the home directory
                                               -- 4: Filename and parent dir, with tilde as the home directory

                      shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                                               -- for other components. (terrible name, any suggestions?)
                      symbols = {
                        modified = '[+]',      -- Text to show when the file is modified.
                        readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
                        unnamed = '[No Name]', -- Text to show for unnamed buffers.
                        newfile = '[New]',     -- Text to show for newly created file before first write
                      },
                    },
                    'branch']]
                },

                lualine_c = {
                    --'%=', 'buffers'
                    '%=',
                    --[[{
                      'buffers',
                        show_filename_only = true,   -- Shows shortened relative path when set to false.
                        hide_filename_extension = false,   -- Hide filename extension when set to true.
                        show_modified_status = true, -- Shows indicator when the buffer is modified.

                        mode = 0, -- 0: Shows buffer name
                                  -- 1: Shows buffer index
                                  -- 2: Shows buffer name + buffer index
                                  -- 3: Shows buffer number
                                  -- 4: Shows buffer name + buffer number

                        max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                                                            -- it can also be a function that returns
                                                            -- the value of `max_length` dynamically.
                        filetype_names = {
                          TelescopePrompt = 'Telescope',
                          --dashboard = 'Dashboard',
                          --packer = 'Packer',
                          fzf = 'FZF',
                          alpha = 'DarthAlpha'
                        }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

                        -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
                        --use_mode_colors = false,

                        buffers_color = {
                          -- Same values as the general color option can be used here.
                          active = 'lualine_{section}_normal',     -- Color for active buffer.
                          inactive = 'lualine_{section}_inactive', -- Color for inactive buffer.
                        },

                        symbols = {
                          modified = ' ●',      -- Text to show when the buffer is modified
                          alternate_file = '#', -- Text to show to identify the alternate file
                          directory =  '',     -- Text to show when the buffer is a directory
                      },
                    }]]
                    },
                lualine_x = {
                    'diagnostics',
                    {
                        'filetype',
                         colored = true,   -- Displays filetype icon in color if set to true
                         icon_only = true, -- Display only an icon for filetype
                         icon = { align = 'right' }, -- Display filetype icon on the right hand side
                         -- icon =    {'X', align='right'}
                         -- Icon string ^ in table is ignored in filetype component
                    }
                },
                --lualine_y = { 'fileformat', 'filetype', 'progress' },
                lualine_y = { 'progress' },
                lualine_z = {
                  { 'location', separator = { right = '' }, left_padding = 2 },
                  "branch"
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
