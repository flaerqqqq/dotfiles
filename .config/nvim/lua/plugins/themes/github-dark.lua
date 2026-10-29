return {
    "projekt0n/github-nvim-theme",
    lazy = true,
    colorscheme = "github_dark",
    background = "dark",
    setup = function()
        require("github-theme").setup({ options = { transparent = true } })
    end,
}
