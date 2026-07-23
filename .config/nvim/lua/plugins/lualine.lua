return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = function()
        local icons = {
            diagnostics = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
            git = { added = "✚", modified = "", removed = "✖" },
        }

        -- pull a color from the active colorscheme's highlight groups,
        -- so this adapts automatically instead of being hardcoded
        local function hl_fg(group, fallback)
            local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
            if ok and hl and hl.fg then
                return string.format("#%06x", hl.fg)
            end
            return fallback
        end

        local function macro_recording()
            local reg = vim.fn.reg_recording()
            if reg == "" then
                return ""
            end
            return "󰑋 @" .. reg
        end

        local function search_count()
            if vim.v.hlsearch == 0 then
                return ""
            end
            local ok, result = pcall(vim.fn.searchcount, { maxcount = 999 })
            if not ok or result.total == 0 then
                return ""
            end
            return string.format(" %d/%d", result.current, result.total)
        end

        local function lsp_clients()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
                return ""
            end
            local names = {}
            for _, c in ipairs(clients) do
                table.insert(names, c.name)
            end
            return " " .. table.concat(names, ", ")
        end

        return {
            options = {
                theme = "auto",
                globalstatus = true,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    { "branch", icon = "" },
                    { "diff", symbols = icons.git, colored = true },
                },
                lualine_c = {
                    { "filename", path = 1, symbols = { modified = "  ●", readonly = "  " } },
                    {
                        macro_recording,
                        color = function()
                            return { fg = hl_fg("DiagnosticWarn", "#e0af68"), gui = "bold" }
                        end,
                    },
                },
                lualine_x = {
                    {
                        "diagnostics",
                        symbols = {
                            error = icons.diagnostics.error,
                            warn = icons.diagnostics.warn,
                            info = icons.diagnostics.info,
                            hint = icons.diagnostics.hint,
                        },
                    },
                    {
                        lsp_clients,
                        color = function()
                            return { fg = hl_fg("Function", "#7aa2f7") }
                        end,
                    },
                    {
                        search_count,
                        color = function()
                            return { fg = hl_fg("Statement", "#bb9af7") }
                        end,
                    },
                    "filetype",
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_c = { "filename" },
                lualine_x = { "location" },
            },
            extensions = { "neo-tree", "lazy", "trouble", "quickfix" },
        }
    end,
}
