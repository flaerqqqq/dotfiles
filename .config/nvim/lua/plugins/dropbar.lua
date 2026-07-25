return {
    "Bekaboo/dropbar.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
        require("dropbar").setup({
            bar = {
                sources = function(_, _)
                    return { require("dropbar.sources").path }
                end,

                -- THE E36 FIX
                enable = function(buf, win, _)
                    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
                        return false
                    end

                    local filetype = vim.bo[buf].filetype
                    local buftype = vim.bo[buf].buftype
                    local excluded = { "notify", "noice", "neo-tree", "TelescopePrompt" }

                    if vim.tbl_contains(excluded, filetype) or buftype ~= "" then
                        return false
                    end

                    return true
                end,
                hover = true,
            },

            sources = {
                path = {
                    relative_to = function(buf, win)
                        local filepath = vim.api.nvim_buf_get_name(buf)
                        local root = vim.fn.getcwd()

                        if not vim.startswith(filepath, root) then
                            return vim.fn.fnamemodify(filepath, ":h")
                        end

                        local win_width = vim.api.nvim_win_get_width(win)
                        local current_root = root

                        while string.len(current_root) < string.len(filepath) do
                            local displayed_path = string.sub(filepath, string.len(current_root) + 2)
                            -- Break the path into individual folder names
                            local parts = vim.split(displayed_path, "/", { plain = true, trimempty = true })

                            -- If we only have the file left, stop hiding folders
                            if #parts <= 1 then
                                break
                            end

                            -- 1. Calculate length of the raw text
                            local text_length = 0
                            for _, part in ipairs(parts) do
                                text_length = text_length + string.len(part)
                            end

                            -- 2. Calculate the exact UI padding
                            -- (~3 cells per icon + space, ~3 cells per "  " separator, + 8 safety margin)
                            local padding_width = (#parts * 3) + ((#parts - 1) * 3) + 8

                            -- 3. Check if the TOTAL physical length fits in the window
                            local total_estimated_width = text_length + padding_width

                            if total_estimated_width <= win_width then
                                break -- It perfectly fits!
                            end

                            -- It doesn't fit, so advance the root forward by one folder to hide it
                            local next_slash = string.find(filepath, "/", string.len(current_root) + 2)
                            if next_slash then
                                current_root = string.sub(filepath, 1, next_slash - 1)
                            else
                                break
                            end
                        end

                        return current_root
                    end,
                },
            },

            icons = {
                enable = true,
                ui = {
                    bar = { separator = "  ", extends = "…" },
                    menu = { separator = " ", indicator = " " },
                },
            },
        })

        -- THE TRANSPARENCY FIX
        vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
    end,
}
