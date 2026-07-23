return {
    "nvim-java/nvim-java",
    config = function()
        require("java").setup({
            jdtls = {
                -- JVM heap allocation for JDTLS
                cmd = {
                    "-Xmx6g",
                },
            },
        })
    end,
}
