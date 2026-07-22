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
                                reveal_file = dir, -- expands/highlights dir
                                reveal_force_cwd = false, -- do NOT change root; matches project cwd
                            })
                        end)
                        return true
                    end,
                })
            end,
            desc = "Find dir (Telescope) -> focus Neo-tree",
        },
    },
    opts = {},
}
