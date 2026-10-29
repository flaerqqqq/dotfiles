local opts = {
    compile = false,
    undercurl = true,
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = true,
    dimInactive = false,
    terminalColors = true,
    colors = {
        palette = {},
        theme = {
            wave = {},
            lotus = {},
            dragon = {},
            all = {
                ui = {
                    float = {
                        bg = "none",
                    },
                    bg_gutter = "none",
                },
            },
        },
    },
    overrides = function(colors)
        local theme = colors.theme
        local palette = colors.palette

        return {
            CursorLine = { bg = "#2D3543" },
            Visual = { bg = "#1D3F57" },
            NeoTreeGitModified = { fg = "#E6C384" },
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },

            WinSeparator = { fg = "#2A2A37", bg = "none" },
            NeoTreeWinSeparator = { fg = palette.sumiInk4, bg = "none" },

            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        }
    end,
    theme = "dragon",
}

return {
    "rebelot/kanagawa.nvim",
    lazy = true,
    colorscheme = "kanagawa-dragon",
    opts = opts,
    -- shared with kanagawa-wave, which sets its own theme
    shared_opts = opts,
    setup = function()
        require("kanagawa").setup(opts)
    end,
}
