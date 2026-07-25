return {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",

    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    opts = {
        open_for_directories = false,

        floating_window_scaling_factor = 0.9,

        yazi_floating_window_border = "rounded",

        keymaps = {
            show_help = "<F1>",

            quit = "<Esc>",
            quit_and_return_to_directory = "<C-c>",
        },
    },

    keys = {
        {
            "<leader>y",
            function()
                require("yazi").yazi()
            end,
            desc = "Open Yazi",
        },
    },
}
