return {
    "folke/snacks.nvim",
    opts = {
        explorer = { enabled = false },
    },
    keys = {
        -- Disable the Snacks explorer keymaps
        { "<leader>e", false },
        { "<leader>E", false },
    },
}
