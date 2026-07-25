return {
    "folke/snacks.nvim",

    opts = {
        explorer = {
            enabled = false,
        },

        scroll = {
            enabled = false,
        },

        indent = {
            enabled = false,
        },

        picker = {
            enabled = true,

            layout = {
                preset = "ivy",
                preview = false,
            },

            formatters = {
                file = {
                    filename_first = true,
                },
            },

            matcher = {
                fuzzy = true,
                smartcase = true,
                ignorecase = true,
                filename_bonus = true,
                cwd_bonus = true,
                frecency = false,
                history_bonus = false,
            },

            sort = {
                fields = {
                    "score:desc",
                    "#text",
                    "idx",
                },
            },

            history = {
                enabled = true,
            },

            icons = {
                files = {
                    enabled = true,
                },
            },

            win = {
                input = {
                    keys = {
                        ["<C-j>"] = {
                            "list_down",
                            mode = { "i", "n" },
                        },
                        ["<C-k>"] = {
                            "list_up",
                            mode = { "i", "n" },
                        },
                        ["<C-u>"] = {
                            "preview_scroll_up",
                            mode = { "i", "n" },
                        },
                        ["<C-d>"] = {
                            "preview_scroll_down",
                            mode = { "i", "n" },
                        },
                        ["<Esc>"] = {
                            "close",
                            mode = { "i", "n" },
                        },
                        ["<CR>"] = {
                            "confirm",
                            mode = { "i", "n" },
                        },
                    },
                },
            },
        },
    },

    keys = {
        {
            "<leader>ff",
            function()
                Snacks.picker.files({ hidden = true })
            end,
            desc = "Find Files",
        },

        {
            "<leader>fg",
            function()
                Snacks.picker.grep({ hidden = true })
            end,
            desc = "Project Search",
        },

        {
            "<leader>fr",
            function()
                Snacks.picker.recent()
            end,
            desc = "Recent Files",
        },

        {
            "<leader>fb",
            function()
                Snacks.picker.buffers()
            end,
            desc = "Buffers",
        },

        {
            "<leader>fn",
            function()
                Snacks.picker.files({ hidden = true })
            end,
            desc = "Find Class/File",
        },

        {
            "<leader>fp",
            function()
                Snacks.picker.diagnostics()
            end,
            desc = "Diagnostics",
        },

        {
            "<leader>fd",
            function()
                Snacks.picker.pick({
                    title = "Directories",
                    format = "text", -- Bypasses the file renderer to safely show the custom icon + fuzzy highlights
                    finder = function()
                        local result = {}
                        for _, dir in ipairs(vim.fn.systemlist("fd --type d --hidden --exclude .git")) do
                            table.insert(result, {
                                text = dir,
                                file = vim.fn.fnamemodify(dir, ":p"), -- Restored to prevent ghost entries!
                                icon = " ",
                                icon_hl = "Directory",
                            })
                        end
                        return result
                    end,
                    confirm = function(picker, item)
                        picker:close()
                        if not item then
                            return
                        end

                        require("neo-tree.command").execute({
                            action = "focus",
                            source = "filesystem",
                            reveal_file = item.file,
                            reveal_force_cwd = false,
                        })
                    end,
                })
            end,
            desc = "Find dir -> focus Neo-tree",
        },

        {
            "<leader>nj",
            function()
                Snacks.picker.pick({
                    title = "New Java File In...",
                    format = "text",
                    finder = function()
                        local result = {}
                        local current_dir = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":.")
                        if current_dir == "" then
                            current_dir = "."
                        end

                        table.insert(result, {
                            text = current_dir,
                            file = vim.fn.fnamemodify(current_dir, ":p"),
                            icon = " ",
                            icon_hl = "Directory",
                        })

                        for _, dir in ipairs(vim.fn.systemlist("fd --type d --hidden --exclude .git")) do
                            if dir ~= current_dir and dir ~= "./" then
                                table.insert(result, {
                                    text = dir,
                                    file = vim.fn.fnamemodify(dir, ":p"),
                                    icon = " ",
                                    icon_hl = "Directory",
                                })
                            end
                        end
                        return result
                    end,
                    confirm = function(picker, item)
                        picker:close()
                        if not item then
                            return
                        end

                        vim.defer_fn(function()
                            require("utils.java-new").create_java_file(item.file)
                        end, 30)
                    end,
                })
            end,
            desc = "New Java File (Directory Picker)",
        },

        {
            "<leader>nd",
            function()
                Snacks.picker.pick({
                    title = "New Directory In...",
                    format = "text",
                    finder = function()
                        local result = {}
                        local current_dir = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":.")
                        if current_dir == "" then
                            current_dir = "."
                        end

                        table.insert(result, {
                            text = current_dir,
                            file = vim.fn.fnamemodify(current_dir, ":p"),
                            icon = " ",
                            icon_hl = "Directory",
                        })

                        for _, dir in ipairs(vim.fn.systemlist("fd --type d --hidden --exclude .git")) do
                            if dir ~= current_dir and dir ~= "./" then
                                table.insert(result, {
                                    text = dir,
                                    file = vim.fn.fnamemodify(dir, ":p"),
                                    icon = " ",
                                    icon_hl = "Directory",
                                })
                            end
                        end
                        return result
                    end,
                    confirm = function(picker, item)
                        picker:close()
                        if not item then
                            return
                        end

                        vim.defer_fn(function()
                            vim.ui.input({ prompt = "Directory Name: " }, function(input)
                                if not input or input == "" then
                                    return
                                end

                                local full_path = item.file .. "/" .. input

                                vim.fn.mkdir(full_path, "p")
                                vim.notify("Created directory: " .. full_path, vim.log.levels.INFO)

                                require("neo-tree.command").execute({
                                    action = "focus",
                                    source = "filesystem",
                                    reveal_file = full_path,
                                    reveal_force_cwd = false,
                                })
                            end)
                        end, 30)
                    end,
                })
            end,
            desc = "New Directory (Directory Picker)",
        },

        {
            "<leader>nf",
            function()
                Snacks.picker.pick({
                    title = "New File In...",
                    format = "text",
                    finder = function()
                        local result = {}
                        local current_dir = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":.")
                        if current_dir == "" then
                            current_dir = "."
                        end

                        table.insert(result, {
                            text = current_dir,
                            file = vim.fn.fnamemodify(current_dir, ":p"),
                            icon = " ",
                            icon_hl = "Directory",
                        })

                        for _, dir in ipairs(vim.fn.systemlist("fd --type d --hidden --exclude .git")) do
                            if dir ~= current_dir and dir ~= "./" then
                                table.insert(result, {
                                    text = dir,
                                    file = vim.fn.fnamemodify(dir, ":p"),
                                    icon = " ",
                                    icon_hl = "Directory",
                                })
                            end
                        end
                        return result
                    end,
                    confirm = function(picker, item)
                        picker:close()
                        if not item then
                            return
                        end

                        vim.defer_fn(function()
                            vim.ui.input({ prompt = "File Name: " }, function(input)
                                if not input or input == "" then
                                    return
                                end

                                local full_path = item.file .. "/" .. input
                                local parent_dir = vim.fn.fnamemodify(full_path, ":h")

                                vim.fn.mkdir(parent_dir, "p")

                                local file = io.open(full_path, "w")
                                if file then
                                    file:write("")
                                    file:close()
                                end

                                vim.schedule(function()
                                    vim.cmd.edit(full_path)
                                    vim.notify("Created file: " .. full_path, vim.log.levels.INFO)

                                    require("neo-tree.command").execute({
                                        action = "focus",
                                        source = "filesystem",
                                        reveal_file = full_path,
                                        reveal_force_cwd = false,
                                    })
                                end)
                            end)
                        end, 30)
                    end,
                })
            end,
            desc = "New File (Directory Picker)",
        },
    },
}
