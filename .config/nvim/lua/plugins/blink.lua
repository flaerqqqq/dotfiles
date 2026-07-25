return {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "insertenter", "cmdlineenter" },
    dependencies = {
        "rafamadriz/friendly-snippets",
        "onsails/lspkind.nvim",
        "nvim-tree/nvim-web-devicons",
    },

    opts = {
        keymap = {
            preset = "default",

            ["<Tab>"] = {
                "select_next",
                "fallback",
            },

            ["<S-Tab>"] = {
                "select_prev",
                "fallback",
            },

            ["<CR>"] = {
                "accept",
                "fallback",
            },

            ["<C-n>"] = { "snippet_forward", "fallback" },
            ["<C-p>"] = { "snippet_backward", "fallback" },
        },

        fuzzy = {
            implementation = "prefer_rust_with_warning",
            max_typos = function()
                return 1
            end,
            use_proximity = false,
        },

        appearance = {
            nerd_font_variant = "mono",
        },

        completion = {
            trigger = {
                show_on_keyword = true,
                show_on_trigger_character = true,
            },

            list = {
                selection = {
                    preselect = false,
                    auto_insert = true,
                },
            },

            accept = {
                auto_brackets = {
                    enabled = true,
                },
            },

            ghost_text = {
                enabled = false,
            },

            documentation = {
                auto_show = true,
                auto_show_delay_ms = 150,
                window = {
                    border = "rounded",
                },
            },

            menu = {
                border = "rounded",
                winhighlight = "normal:blinkcmpmenu,floatborder:blinkcmpmenuborder,cursorline:blinkcmpmenuselection,search:none",
                draw = {
                    treesitter = { "lsp" },
                    columns = {
                        { "kind_icon", "label", gap = 1 },
                        { "kind" },
                        { "source_name" },
                    },
                    components = {
                        label = {
                            width = {
                                fill = true,
                                max = 45,
                            },
                        },
                        label_description = {
                            width = {
                                max = 45,
                            },
                        },
                        kind_icon = {
                            text = function(ctx)
                                local lspkind = require("lspkind")
                                local icon = ctx.kind_icon

                                if ctx.source_name == "path" then
                                    if ctx.kind == "folder" then
                                        icon = ""
                                    else
                                        local dev_icon = require("nvim-web-devicons").get_icon(ctx.label)
                                        icon = dev_icon or icon
                                    end
                                else
                                    icon = lspkind.symbolic(ctx.kind, { mode = "symbol" })
                                end

                                return icon .. ctx.icon_gap
                            end,

                            highlight = function(ctx)
                                local hl = ctx.kind_hl

                                if ctx.source_name == "path" and ctx.kind ~= "folder" then
                                    local _, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                    hl = dev_hl or hl
                                end

                                return hl
                            end,
                        },
                    },
                },
            },
        },

        signature = {
            enabled = true,
            window = {
                border = "rounded",
            },
        },

        sources = {
            default = {
                "lsp",
                "path",
                "snippets",
                "buffer",
            },
            providers = {
                lsp = {
                    score_offset = 100,
                },
                path = {
                    score_offset = 50,
                },
                snippets = {
                    score_offset = 25,
                },
                buffer = {
                    min_keyword_length = 3,
                    max_items = 4,
                    score_offset = -25,
                },
            },
        },

        cmdline = {
            enabled = true,
            keymap = {
                preset = "cmdline",
                ["<a-space>"] = {
                    "show",
                    "show_documentation",
                    "hide_documentation",
                },
            },
            completion = {
                menu = {
                    auto_show = true,
                },
                ghost_text = {
                    enabled = false,
                },
            },
        },
    },
}
