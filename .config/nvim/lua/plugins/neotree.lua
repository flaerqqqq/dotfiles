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
        window = { position = "left", width = 35 },
        default_component_configs = {
            git_status = {
                symbols = {
                    added = "✚",
                    modified = "",
                    deleted = "✖",
                    renamed = "󰁕",
                    untracked = "",
                    ignored = "",
                    unstaged = "󰄱",
                    staged = "",
                    conflict = "",
                },
            },
            diagnostics = {
                symbols = {
                    hint = "󰌵 ",
                    info = " ",
                    warn = " ",
                    error = " ",
                },
            },
        },
    },
    keys = {
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer (Neo-tree)" },
    },
}
