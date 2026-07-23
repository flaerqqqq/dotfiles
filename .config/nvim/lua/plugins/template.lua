return {
    "nvimdev/template.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = { "Template", "TemProject" },
    config = function()
        require("template").setup({
            temp_dir = vim.fn.stdpath("config") .. "/templates",
        })
    end,
}
