return {
    -- =========================================================================
    -- 1. TREESITTER & CORE PARSERS
    -- =========================================================================
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        init = function()
            -- Auto-start treesitter highlighting and indents
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
        config = function()
            local ensure_installed = {
                "bash",
                "c",
                "html",
                "java",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
                "xml",
            }

            -- Asynchronously install missing parsers on startup
            vim.schedule(function()
                local installed = require("nvim-treesitter.config").get_installed()
                local to_install = vim.tbl_filter(function(p)
                    return not vim.tbl_contains(installed, p)
                end, ensure_installed)

                if #to_install > 0 then
                    require("nvim-treesitter").install(to_install)
                end
            end)

            -- Register filetype fallbacks for parsers
            vim.treesitter.language.register("bash", "zsh")
            vim.treesitter.language.register("yaml", "github-actions")
            vim.treesitter.language.register("markdown", "devtools-detail")
        end,
    },

    -- =========================================================================
    -- 2. TREESITTER TEXTOBJECTS & EXTENSIONS
    -- =========================================================================
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                },
            })

            -- Modern keymaps targeting main branch API
            local select_obj = function(query)
                return function()
                    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
                end
            end

            vim.keymap.set({ "x", "o" }, "af", select_obj("@function.outer"), { desc = "Around function" })
            vim.keymap.set({ "x", "o" }, "if", select_obj("@function.inner"), { desc = "Inside function" })
            vim.keymap.set({ "x", "o" }, "ac", select_obj("@class.outer"), { desc = "Around class" })
            vim.keymap.set({ "x", "o" }, "ic", select_obj("@class.inner"), { desc = "Inside class" })
        end,
    },

    -- Mini.ai: Modern replacement for targets.vim
    {
        "nvim-mini/mini.ai",
        version = "*",
        event = { "BufReadPost", "BufNewFile" },
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    -- Balanced brackets / blocks textobject 'B'
                    B = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                },
            }
        end,
    },

    -- Various Text Objects (subword / assignment values)
    {
        "chrisgrieser/nvim-various-textobjs",
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            {
                "as",
                "<cmd>lua require('various-textobjs').subword(false)<CR>",
                mode = { "o", "x" },
                desc = "Subword outer",
            },
            {
                "is",
                "<cmd>lua require('various-textobjs').subword(true)<CR>",
                mode = { "o", "x" },
                desc = "Subword inner",
            },
            {
                "il",
                "<cmd>lua require('various-textobjs').value(true)<CR>",
                mode = { "o", "x" },
                desc = "Assignment LHS/RHS value",
            },
        },
    },
}
