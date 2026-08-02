return {
    "nvim-java/nvim-java",
    config = function()
        require("java").setup({})

        vim.lsp.config("jdtls", {
            settings = {
                java = {
                    -- Disable the buggy parameter hints (from earlier)
                    inlayHints = {
                        parameterNames = {
                            enabled = "none",
                        },
                    },
                    -- Replicate IntelliJ's auto-import smarts
                    completion = {
                        -- Hide garbage packages so common classes aren't ambiguous anymore
                        filteredTypes = {
                            "java.awt.*",
                            "com.sun.*",
                            "sun.*",
                            "jdk.*",
                            "org.graalvm.*",
                            "io.micrometer.shaded.*",
                        },
                        -- Sort imports the way IntelliJ does
                        importOrder = {
                            "java",
                            "javax",
                            "com",
                            "org",
                        },
                    },
                },
            },
        })
    end,
}
