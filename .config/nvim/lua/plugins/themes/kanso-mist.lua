return {
    "webhooked/kanso.nvim",
    lazy = true,
    colorscheme = "kanso-mist",
    background = "dark",
    setup = function()
        require("kanso").setup({ transparent = true })
    end,
}
