return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },

        opts = {
            indent = {
                char = "│",
                tab_char = "│",
                highlight = "LineNr",
            },

            whitespace = {
                remove_blankline_trail = false,
            },

            scope = {
                enabled = false,
            },

            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "lazy",
                    "mason",
                    "notify",
                    "snacks_dashboard",
                    "snacks_picker_input",
                    "neo-tree",
                    "NvimTree",
                    "Trouble",
                    "terminal",
                    "toggleterm",
                },
                buftypes = {
                    "terminal",
                    "nofile",
                    "quickfix",
                    "prompt",
                },
            },
        },
    },
}
