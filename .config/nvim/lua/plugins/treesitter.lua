---@diagnostic disable: lowercase-global
    --treesitter
return{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        ensure_installed = {"lua", "python", "css", "json","jsonc", "rasi", "bash"}
        highlight = { enable = true}
        --auto_install = true
        indent = { enable = true}
        sync_install = true
    end


}
