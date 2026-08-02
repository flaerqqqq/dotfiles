vim.schedule(function()
    vim.cmd([[setlocal cino=j1,(2s,u2s,+2s]])
end)

-- Save the default handler just in case UI plugins (like fidget/noice) are using it
local default_status_handler = vim.lsp.handlers["language/status"]

vim.lsp.handlers["language/status"] = function(err, result, ctx, config)
    -- 1. Let existing plugins do their thing (e.g., UI loading spinners)
    if default_status_handler then
        default_status_handler(err, result, ctx, config)
    end

    -- 2. Listen for the exact "I am fully loaded" event from JDTLS
    if result and result.type == "ServiceReady" then
        local java_search = require("utils.java_search")

        -- 3. Trigger the indexer safely!
        if #java_search.all_classes == 0 then
            -- We wrap it in vim.schedule because LSP handlers run in a fast
            -- async context, and vim.notify needs to run on the main thread
            vim.schedule(function()
                java_search.build_index()
            end)
        end
    end
end
