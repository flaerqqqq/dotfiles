-- Helper function to smartly determine the current directory
local function get_context_dir()
    -- 1. If we are focused inside Neo-tree, grab the exact node under the cursor
    if vim.bo.filetype == "neo-tree" then
        local ok, manager = pcall(require, "neo-tree.sources.manager")
        if ok then
            -- Get state for the specific active window
            local state = manager.get_state_for_window(vim.api.nvim_get_current_win())
            if state and state.tree then
                local node = state.tree:get_node()
                if node then
                    -- If it's a file, get its parent. If it's a dir, use it directly.
                    local path = node.type == "directory" and node.path or vim.fn.fnamemodify(node.path, ":h")

                    -- Convert to a relative path
                    local rel_path = vim.fn.fnamemodify(path, ":.")
                    return rel_path == "" and "." or rel_path
                end
            end
        end
    end

    -- 2. Otherwise, fallback to the directory of the active file buffer
    local path = vim.fn.expand("%:p:h")
    return path == "" and "." or vim.fn.fnamemodify(path, ":.")
end

return {
    "folke/snacks.nvim",

    opts = {
        explorer = { enabled = false },
        scroll = { enabled = false },
        indent = { enabled = false },

        picker = {
            enabled = true,
            layout = {
                preset = "default",
                preview = false,
            },
            formatters = {
                file = { filename_first = true },
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
                fields = { "score:desc", "#text", "idx" },
            },
            history = { enabled = true },
            icons = { files = { enabled = true } },
            win = {
                input = {
                    keys = {
                        ["<C-j>"] = { "list_down", mode = { "i", "n" } },
                        ["<C-k>"] = { "list_up", mode = { "i", "n" } },
                        ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                        ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                        ["<Esc>"] = { "close", mode = { "i", "n" } },
                        ["<CR>"] = { "confirm", mode = { "i", "n" } },
                    },
                },
            },
        },
    },

    keys = {
        { "<leader>e", false },
        { "<leader>E", false },
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
                    format = "text",
                    finder = function()
                        local result = {}
                        for _, dir in ipairs(vim.fn.systemlist("fd --type d --hidden --exclude .git")) do
                            table.insert(result, {
                                text = dir,
                                file = vim.fn.fnamemodify(dir, ":p"),
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
                local current_dir = get_context_dir()

                Snacks.picker.pick({
                    title = "New Java File In...",
                    format = "text",
                    finder = function()
                        local result = {}
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
                local current_dir = get_context_dir()

                Snacks.picker.pick({
                    title = "New Directory In...",
                    format = "text",
                    finder = function()
                        local result = {}
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
                            vim.ui.input({ prompt = "Directory Name (e.g. package.name): " }, function(input)
                                if not input or input == "" then
                                    return
                                end

                                -- Convert IntelliJ-style dot notation to slashes
                                local parsed_input = input:gsub("%.", "/")

                                -- Re-attach the leading dot if you meant to create a hidden folder like ".github"
                                if input:sub(1, 1) == "." then
                                    parsed_input = "." .. input:sub(2):gsub("%.", "/")
                                end

                                local full_path = item.file .. "/" .. parsed_input

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
                local current_dir = get_context_dir()

                Snacks.picker.pick({
                    title = "New File In...",
                    format = "text",
                    finder = function()
                        local result = {}
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
