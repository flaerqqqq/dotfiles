vim.opt.diffopt = "iwhiteall,internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:patience"

-- Indentation & Tab Defaults
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Whitespace & Indent Character Display
vim.opt.list = true
vim.opt.listchars:append({
    tab = "  ",
    trail = "·",
    nbsp = "&",
})

if os.getenv("SSH_TTY") ~= nil then
    local function my_paste(_reg)
        return function(_lines)
            local content = vim.fn.getreg('"')
            return vim.split(content, "\n")
        end
    end

    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
            ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        paste = {
            ["+"] = my_paste("+"),
            ["*"] = my_paste("*"),
        },
    }
end
vim.opt.fillchars:append({
    vert = "▏", -- Left 1/8th block

    horiz = "—", -- Bottom-aligned 1/8th block (Uncomment this one if you prefer it lower)

    verthoriz = "—",
    horizup = "—",
    horizdown = "—",
    vertleft = "▏",
    vertright = "▏",
})
vim.opt.swapfile = false -- Disable swap files (modern setups rarely need them)
vim.opt.undofile = true
