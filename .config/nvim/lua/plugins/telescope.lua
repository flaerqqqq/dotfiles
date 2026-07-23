return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        {
            "<leader>fd",
            function()
                local previewers = require("telescope.previewers")
                local putils = require("telescope.previewers.utils")
                local clean_dir_previewer = previewers.new_buffer_previewer({
                    title = "Directory Contents",
                    define_preview = function(self, entry, status)
                        local dir = entry.path or entry[1]
                        putils.job_maker({ "ls", "-1Ap", dir }, self.state.bufnr, {
                            value = dir,
                            bufname = self.state.bufname,
                        })
                    end,
                })

                require("telescope.builtin").find_files({
                    prompt_title = "Directories",
                    previewer = clean_dir_previewer,
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
                local current_dir = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":.")
                if current_dir == "" then
                    current_dir = "."
                end

                local previewers = require("telescope.previewers")
                local putils = require("telescope.previewers.utils")
                local clean_dir_previewer = previewers.new_buffer_previewer({
                    title = "Directory Contents",
                    define_preview = function(self, entry, status)
                        local dir = entry.path or entry[1]
                        putils.job_maker({ "ls", "-1Ap", dir }, self.state.bufnr, {
                            value = dir,
                            bufname = self.state.bufname,
                        })
                    end,
                })

                require("telescope.builtin").find_files({
                    prompt_title = "New Java File In...",
                    previewer = clean_dir_previewer,
                    find_command = { "sh", "-c", "echo '" .. current_dir .. "' && fd --type d --hidden --exclude .git" },
                    attach_mappings = function(prompt_bufnr, map)
                        local actions = require("telescope.actions")
                        local action_state = require("telescope.actions.state")
                        actions.select_default:replace(function()
                            local entry = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            if not entry then
                                return
                            end
                            local dir = entry.path or entry[1]
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
        {
            "<leader>jp",
            function()
                local current_dir = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":.")
                if current_dir == "" then
                    current_dir = "."
                end

                local previewers = require("telescope.previewers")
                local putils = require("telescope.previewers.utils")
                local clean_dir_previewer = previewers.new_buffer_previewer({
                    title = "Directory Contents",
                    define_preview = function(self, entry, status)
                        local dir = entry.path or entry[1]
                        putils.job_maker({ "ls", "-1Ap", dir }, self.state.bufnr, {
                            value = dir,
                            bufname = self.state.bufname,
                        })
                    end,
                })

                require("telescope.builtin").find_files({
                    prompt_title = "New Package In...",
                    previewer = clean_dir_previewer,
                    find_command = { "sh", "-c", "echo '" .. current_dir .. "' && fd --type d --hidden --exclude .git" },
                    attach_mappings = function(prompt_bufnr, map)
                        local actions = require("telescope.actions")
                        local action_state = require("telescope.actions.state")
                        actions.select_default:replace(function()
                            local entry = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            if not entry then
                                return
                            end
                            local dir = entry.path or entry[1]

                            vim.defer_fn(function()
                                vim.ui.input({ prompt = "Package Name: " }, function(input)
                                    if not input or input == "" then
                                        return
                                    end

                                    local formatted_path = input:gsub("%.", "/")
                                    local full_path = dir .. "/" .. formatted_path

                                    vim.fn.mkdir(full_path, "p")
                                    vim.notify("Created package: " .. full_path, vim.log.levels.INFO)

                                    require("neo-tree.command").execute({
                                        action = "focus",
                                        source = "filesystem",
                                        reveal_file = full_path,
                                        reveal_force_cwd = false,
                                    })
                                end)
                            end, 30)
                        end)
                        return true
                    end,
                })
            end,
            desc = "New Java Package (Telescope directory picker)",
        },
    },
    opts = {},
}
