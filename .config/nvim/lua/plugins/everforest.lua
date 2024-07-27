return
{
  "neanias/everforest-nvim",
  version = false,
  lazy = false,
  priority = 1000, -- make sure to load this before all the other start plugins
  -- Optional; default configuration will be used if setup isn't called.
  config = function()
    require("everforest").setup({
      -- Your config here
      background = "soft",--hardness of background
      ---The contrast of line numbers, indent lines,
      ui_contrast = "low",
      transparent_background_level = 2,
      diagnostic_virtual_text = "coloured",
      diagnostic_text_highlight = false,
      diagnostic_line_highlight = false,
      vim.cmd([[colorscheme everforest]])
    })
  end,
}
