return {
    "webhooked/kanso.nvim",
    lazy = true,
    colorscheme = "kanso-zen",
    background = "dark",
    setup = function()
        require("kanso").setup({ transparent = true })
    end,
}
