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

vim.keymap.set("n", "<leader>ri", function()
    vim.lsp.buf.code_action({
        -- This filter function looks at all available code actions
        -- and throws away everything except the actual import choices.
        filter = function(action)
            -- JDTLS always names its import resolutions starting with "Import '"
            -- Example: "Import 'List' (java.util)"
            return string.match(action.title, "^Import '") ~= nil
        end,
        -- If there is only one choice, apply it instantly without asking!
        apply = true,
    })
end, { desc = "Resolve Import (Clean IntelliJ Style)" })

-- 2. The File-wide Organize Imports (Run this after resolving ambiguities)
vim.keymap.set("n", "<leader>oi", function()
    local clients = vim.lsp.get_clients({ name = "jdtls", bufnr = 0 })
    if #clients == 0 then
        return
    end
    vim.lsp.buf.execute_command({
        command = "java.edit.organizeImports",
        arguments = { vim.uri_from_bufnr(0) },
    })
end, { desc = "Organize Imports (JDTLS Direct)" })

vim.keymap.set("n", "<leader>jb", "<Cmd>JavaBuildBuildWorkspace<CR>", { desc = "Build Java Workspace" })
