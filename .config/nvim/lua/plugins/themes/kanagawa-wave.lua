return {
    "rebelot/kanagawa.nvim",
    lazy = true,
    colorscheme = "kanagawa-wave",
    background = "dark",
    setup = function()
        local base = require("plugins.themes.kanagawa-dragon").shared_opts
        require("kanagawa").setup(vim.tbl_extend("force", base, { theme = "wave" }))
    end,
}
