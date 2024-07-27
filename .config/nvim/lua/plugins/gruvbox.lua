-- gruvbox theme
return
{
    "ellisonleao/gruvbox.nvim",
    --lazy=false,
    --priority -load this before all other start plugins
    priority = 1000 ,
    config = function()
        -- Default options:
        require("gruvbox").setup({
          terminal_colors = true, -- add neovim terminal colors
          undercurl = true,
          underline = true,
          bold = true,
          italic = {
            strings = true,
            emphasis = true,
            comments = true,
            operators = false,
            folds = true,
          },
          strikethrough = true,
          invert_selection = false,
          invert_signs = false,
          invert_tabline = false,
          invert_intend_guides = false,
          inverse = true, -- invert background for search, diffs, statuslines and errors
          contrast = "soft", -- can be "hard", "soft" or empty string
          palette_overrides = {},
          overrides = {},
          dim_inactive = true,
          transparent_mode = false,
        })
        vim.cmd("colorscheme gruvbox")
    end
}

