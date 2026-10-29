return {
    "navarasu/onedark.nvim",
    lazy = true,
    colorscheme = "onedark",
    background = "dark",
    setup = function()
        require("onedark").setup({ style = "dark", transparent = true })
    end,
}
