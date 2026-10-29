return {
    "Shatur/neovim-ayu",
    lazy = true,
    colorscheme = "ayu-mirage",
    background = "dark",
    setup = function()
        require("ayu").setup({
            mirage = true,
            overrides = {
                Normal = { bg = "None" },
                NormalNC = { bg = "None" },
                NormalFloat = { bg = "None" },
                SignColumn = { bg = "None" },
            },
        })
    end,
}
