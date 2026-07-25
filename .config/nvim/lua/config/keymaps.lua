local keys = {
    "<leader>g",
    "<leader>gb",
    "<leader>gB",
    "<leader>gd",
    "<leader>gf",
    "<leader>gg",
    "<leader>gl",
    "<leader>gL",
    "<leader>gp",
    "<leader>gP",
    "<leader>gs",
    "<leader>gS",
    "<leader>gy",
}

for _, key in ipairs(keys) do
    pcall(vim.keymap.del, "n", key)
end
