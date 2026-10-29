return {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    colorscheme = "gruvbox",
    background = "dark",
    setup = function()
        require("gruvbox").setup({ terminal_colors = true, contrast = "hard", transparent_mode = true })
    end,
}
