return {
    "nvim-java/nvim-java",
    config = function()
        require("java").setup()

        vim.lsp.config("jdtls", {
            settings = {
                java = {
                    inlayHints = {
                        parameterNames = {
                            enabled = "none",
                        },
                    },
                },
            },
        })
    end,
}
