return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        {
            "<leader>fd",
            function()
                require("telescope.builtin").find_files({
                    prompt_title = "Directories",
                    find_command = { "fd", "--type", "d", "--hidden", "--exclude", ".git" },
                    attach_mappings = function(prompt_bufnr, map)
                        local actions = require("telescope.actions")
                        local action_state = require("telescope.actions.state")
                        actions.select_default:replace(function()
                            local entry = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            local dir = entry.path or entry[1]
                            if not dir then
                                return
                            end
                            require("neo-tree.command").execute({
                                action = "focus",
                                source = "filesystem",
                                reveal_file = dir,
                                reveal_force_cwd = false,
                            })
                        end)
                        return true
                    end,
                })
            end,
            desc = "Find dir (Telescope) -> focus Neo-tree",
        },
        {
            "<leader>jn",
            function()
                require("telescope.builtin").find_files({
                    prompt_title = "New Java File In...",
                    find_command = { "fd", "--type", "d", "--hidden", "--exclude", ".git" },
                    attach_mappings = function(prompt_bufnr, map)
                        local actions = require("telescope.actions")
                        local action_state = require("telescope.actions.state")
                        actions.select_default:replace(function()
                            local entry = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            local dir = entry.path or entry[1]
                            if not dir then
                                return
                            end
                            vim.defer_fn(function()
                                require("utils.java-new").create_java_file(dir)
                            end, 30)
                        end)
                        return true
                    end,
                })
            end,
            desc = "New Java File (Telescope directory picker)",
        },
    },
    opts = {},
}
