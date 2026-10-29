return {
    "webhooked/kanso.nvim",
    lazy = true,
    colorscheme = "kanso-ink",
    background = "dark",
    setup = function()
        require("kanso").setup({
            transparent = true,
        })
    end,
}
