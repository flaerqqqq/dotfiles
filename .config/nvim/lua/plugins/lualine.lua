return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local success, theme = pcall(require, "lualine.themes.kanagawa")

        if success then
            -- 1. Grab the exact colors Normal mode uses for the Git/Filename section
            local b_bg = theme.normal.b.bg
            local b_fg = theme.normal.b.fg

            local modes = { "normal", "insert", "visual", "command", "replace", "inactive" }
            for _, mode in ipairs(modes) do
                if theme[mode] then
                    -- 2. Keep the middle section transparent
                    if theme[mode].c then
                        theme[mode].c.bg = "NONE"
                    end

                    -- 3. Force the Git/Filename section (b) to stay solid across ALL modes
                    if theme[mode].b then
                        theme[mode].b.bg = b_bg
                        if not theme[mode].b.fg then
                            theme[mode].b.fg = b_fg
                        end
                    else
                        theme[mode].b = { bg = b_bg, fg = b_fg }
                    end
                end
            end
        else
            theme = "auto"
        end

        require("lualine").setup({
            options = {
                theme = theme,
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                globalstatus = true,
            },
            sections = {
                -- Left Side
                lualine_a = {
                    { "mode", icon = "" },
                },
                lualine_b = {
                    { "filename", path = 0 },
                    { "branch", icon = "" },
                },

                -- Middle
                lualine_c = {},
                lualine_x = {},

                -- Right Side
                lualine_y = {},
                lualine_z = {
                    { "location", icon = "" },
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { "filename", path = 0 } },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
        })

        -- Wipes leftover black/dark background from the empty spaces
        vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
    end,
}
