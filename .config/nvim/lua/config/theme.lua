local M = {}

local state_dir = (vim.env.XDG_STATE_HOME or vim.fn.expand("~/.local/state")) .. "/theme"
local state_file = state_dir .. "/current"
-- nvim-only choice made in the picker; the `theme` script clears it
local nvim_file = state_dir .. "/nvim"

local function read(path)
    local f = io.open(path, "r")
    if not f then
        return nil
    end
    local id = f:read("*l")
    f:close()
    return id
end

function M.current()
    return read(nvim_file) or read(state_file)
end

function M.apply(id)
    local spec = require("plugins.themes." .. id)
    require("lazy").load({ plugins = { spec[1]:match("[^/]+$") } })
    if spec.setup then
        spec.setup()
    end
    vim.o.background = spec.background or "dark"
    vim.cmd.colorscheme(spec.colorscheme)
    vim.g.active_theme = id
end

function M.pick()
    local dir = vim.fn.stdpath("config") .. "/lua/plugins/themes"
    local current = M.current()
    local items = {}
    for _, file in ipairs(vim.fn.globpath(dir, "*.lua", false, true)) do
        local id = vim.fn.fnamemodify(file, ":t:r")
        items[#items + 1] = { text = id, id = id, current = id == current }
    end
    Snacks.picker.pick({
        title = "Theme",
        items = items,
        format = function(item)
            return { { (item.current and "* " or "  ") .. item.id } }
        end,
        layout = { preset = "select" },
        confirm = function(picker, item)
            picker:close()
            if not item then
                return
            end
            M.apply(item.id)
            vim.fn.mkdir(state_dir, "p")
            local f = io.open(nvim_file, "w")
            if f then
                f:write(item.id, "\n")
                f:close()
            end
        end,
    })
end

vim.api.nvim_create_autocmd("FocusGained", {
    callback = function()
        local id = M.current()
        if id and id ~= vim.g.active_theme then
            M.apply(id)
        end
    end,
})

return M
