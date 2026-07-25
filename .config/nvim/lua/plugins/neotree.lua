return {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    priority = 1000,
    init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function(data)
                local is_dir = vim.fn.isdirectory(data.file) == 1
                if is_dir then
                    require("neo-tree.command").execute({ action = "focus", dir = data.file })
                end
            end,
        })
    end,
    opts = {
        close_if_last_window = true,
        popup_border_style = "rounded",

        filesystem = {
            group_empty_dirs = true, -- Collapses chains like src/main/java/ into one line
            scan_mode = "deep", -- Scans deep so nested empty folders collapse/expand instantly
            bind_to_cwd = true,
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            hijack_netrw_behavior = "disabled",
            use_libuv_file_watcher = true,
            filtered_items = {
                visible = false,
                hide_dotfiles = false,
                hide_gitignored = false,
            },
            commands = {
                java_new_file = function(state)
                    local node = state.tree:get_node()
                    local dir = node.type == "directory" and node.path or vim.fn.fnamemodify(node.path, ":h")
                    require("utils.java-new").create_java_file(dir)
                end,
            },
            window = {
                mappings = {
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                    ["h"] = "close_node",
                    ["l"] = "open",
                    ["N"] = "java_new_file", -- create Java file in selected directory
                },
            },
        },
        window = { position = "left", width = 45 },

        default_component_configs = {
            container = {
                enable_character_fade = true,
                width = "100%",
                right_padding = 0,
            },
            diagnostics = {
                symbols = {
                    hint = "H",
                    info = "I",
                    warn = "!",
                    error = "X",
                },
                highlights = {
                    hint = "DiagnosticSignHint",
                    info = "DiagnosticSignInfo",
                    warn = "DiagnosticSignWarn",
                    error = "DiagnosticSignError",
                },
            },
            -- 1. THIN INDENT GUIDES & EXPANDERS
            indent = {
                indent_size = 2,
                padding = 1,
                -- indent guides
                with_markers = true,
                indent_marker = " ",
                last_indent_marker = " ",
                highlight = "NeoTreeIndentMarker",
                -- expander config, needed for nesting files
                with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                expander_highlight = "NeoTreeExpander",
            },
            -- 2. MODERN FOLDER & FILE ICONS
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "󱞞",
                folder_empty_open = "󱞞",
                use_filtered_colors = true, -- Whether to use a different highlight when the file is filtered (hidden, dotfile, etc.).
                -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                -- then these will never be used.
                default = "*",
                highlight = "NeoTreeFileIcon",
                provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
                    if node.id == state.path then
                        icon.text = ""
                        icon.highlight = ""
                        return
                    end
                    if node.type == "file" or node.type == "terminal" then
                        local success, web_devicons = pcall(require, "nvim-web-devicons")
                        local name = node.type == "terminal" and "terminal" or node.name
                        if success then
                            local devicon, hl = web_devicons.get_icon(name)
                            icon.text = devicon or icon.text
                            icon.highlight = hl or icon.highlight
                        end
                    end
                end,
            },
            modified = {
                symbol = "● ",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = false,
                highlight_opened_files = false, -- Requires `enable_opened_markers = true`.
                -- Take values in { false (no highlight), true (only loaded),
                -- "all" (both loaded and unloaded)}. For more information,
                -- see the `show_unloaded` config of the `buffers` source.
                use_filtered_colors = true, -- Whether to use a different highlight when the file is filtered (hidden, dotfile, etc.).
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },
            git_status = {
                symbols = {
                    -- Change type
                    added = "+", -- NOTE: you can set any of these to an empty string to not show them
                    deleted = "✗",
                    modified = "",
                    renamed = "󰕛 ",
                    -- Status type
                    untracked = "?",
                    ignored = "",
                    unstaged = "!",
                    staged = "+",
                    conflict = "",
                },
                align = "left",
            },
            -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
            file_size = {
                enabled = true,
                width = 12, -- width of the column
                required_width = 64, -- min width of window required to show this column
            },
            type = {
                enabled = true,
                width = 10, -- width of the column
                required_width = 110, -- min width of window required to show this column
            },
            last_modified = {
                enabled = true,
                width = 20, -- width of the column
                required_width = 88, -- min width of window required to show this column
                format = "%Y-%m-%d %I:%M %p", -- format string for timestamp (see `:h os.date()`)
                -- or use a function that takes in the date in seconds and returns a string to display
                --format = require("neo-tree.utils").relative_date, -- enable relative timestamps
            },
            created = {
                enabled = true,
                width = 20, -- width of the column
                required_width = 120, -- min width of window required to show this column
                format = "%Y-%m-%d %I:%M %p", -- format string for timestamp (see `:h os.date()`)
                -- or use a function that takes in the date in seconds and returns a string to display
                --format = require("neo-tree.utils").relative_date, -- enable relative timestamps
            },
            symlink_target = {
                enabled = true,
                text_format = " ➛ %s", -- %s will be replaced with the symlink target's path.
            },
        },
    },
    keys = {
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer (Neo-tree)" },
    },
}
