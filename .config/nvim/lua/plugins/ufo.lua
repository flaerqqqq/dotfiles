return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    opts = {
        provider_selector = function(bufnr, filetype, buftype)
            return { "lsp", "indent" }
        end,
        -- THIS IS THE MAGIC:
        -- UFO will wait for the LSP promise to resolve, identify the 'imports' block,
        -- and fold it automatically before yielding back to the UI.
        close_fold_kinds_for_ft = {
            java = { "imports", "comment" },
        },
    },
    config = function(_, opts)
        vim.o.foldcolumn = "1"
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        require("ufo").setup(opts)
    end,
}
