return
{
  "neanias/everforest-nvim",
  version = false,
  lazy = true,
  priority = 1000, -- make sure to load this before all the other start plugins
  -- Optional; default configuration will be used if setup isn't called.
  config = function()
    require("everforest").setup({
      -- Your config here
      background = "hard",--hardness of background
      ---The contrast of line numbers, indent lines,
      ui_contrast = "high",
      transparent_background_level = 0,
      diagnostic_virtual_text = "coloured",
      diagnostic_text_highlight = false,
      diagnostic_line_highlight = false,

      -- Enable everforest
      --vim.cmd([[colorscheme everforest]]),
      --require("everforest").load()
    })
  end,
}
