return {
    "LazyVim/LazyVim",
    opts = {
        colorscheme = function()
            local theme = require("config.theme")
            theme.apply(theme.current() or "kanagawa-dragon")
        end,
    },
}
