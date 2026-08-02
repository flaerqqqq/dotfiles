local M = {}

M.jar_cache = {}
M.all_classes = {}
M.is_indexing = false -- THE LOCK: Prevents multiple concurrent jobs

-- A helper function to process a massive list without exploding the OS file limit
local function process_in_batches(items, batch_size, process_fn, on_complete)
    local index = 1

    local function next_batch()
        if index > #items then
            if on_complete then
                on_complete()
            end
            return
        end

        local end_idx = math.min(index + batch_size - 1, #items)
        local active_jobs = end_idx - index + 1
        local completed_in_batch = 0

        for i = index, end_idx do
            process_fn(items[i], function()
                completed_in_batch = completed_in_batch + 1
                if completed_in_batch == active_jobs then
                    index = end_idx + 1
                    vim.schedule(next_batch)
                end
            end)
        end
    end

    next_batch()
end

-- Background job to read JARs and ZIPs blazingly fast
local function index_archive(archive_path, callback)
    if M.jar_cache[archive_path] then
        callback(M.jar_cache[archive_path])
        return
    end

    vim.system({ "unzip", "-l", archive_path }, { text = true }, function(obj)
        if obj.code ~= 0 then
            callback({})
            return
        end

        local classes = {}
        for file_path in obj.stdout:gmatch("%S+") do
            local ext = file_path:match("%.(class)$") or file_path:match("%.(java)$")

            if ext and not file_path:match("%$") and not file_path:match("module%-info") then
                local name = file_path:match("([^/]+)%." .. ext .. "$")
                local pkg = file_path:gsub("/[^/]+%." .. ext .. "$", ""):gsub("/", ".")

                table.insert(classes, {
                    name = name,
                    pkg = pkg,
                    jar = archive_path,
                    text = name,
                })
            end
        end

        M.jar_cache[archive_path] = classes
        callback(classes)
    end)
end

function M.build_index()
    -- 1. If we are already indexing, or already have classes, abort immediately!
    if M.is_indexing or #M.all_classes > 0 then
        return
    end

    local clients = vim.lsp.get_clients({ name = "jdtls", bufnr = 0 })
    if #clients == 0 then
        return
    end

    local client = clients[1]

    -- 2. Lock the indexer so no other module can trigger it
    M.is_indexing = true

    client.request("workspace/executeCommand", { command = "java.project.getAll" }, function(err, project_uris)
        if err or not project_uris or #project_uris == 0 then
            M.is_indexing = false -- Unlock on error
            return
        end

        local unique_archives = {}
        local archives_list = {}
        local pending_requests = #project_uris
        local options = vim.fn.json_encode({ scope = "test" })

        local function finalize_indexing()
            local java_home = os.getenv("JAVA_HOME")
            if java_home then
                local src_zip_1 = java_home .. "/lib/src.zip"
                local src_zip_2 = java_home .. "/src.zip"

                if vim.fn.filereadable(src_zip_1) == 1 then
                    table.insert(archives_list, src_zip_1)
                elseif vim.fn.filereadable(src_zip_2) == 1 then
                    table.insert(archives_list, src_zip_2)
                end
            end

            if #archives_list == 0 then
                M.is_indexing = false -- Unlock if nothing to do
                return
            end

            vim.notify(
                "Indexing " .. #archives_list .. " Java dependencies. This may take a moment...",
                vim.log.levels.INFO
            )

            local temp_classes = {}
            local seen_classes = {}

            process_in_batches(archives_list, 30, function(archive, on_job_done)
                index_archive(archive, function(classes)
                    for _, c in ipairs(classes) do
                        local full_class_name = c.pkg .. "." .. c.name
                        if not seen_classes[full_class_name] then
                            seen_classes[full_class_name] = true
                            table.insert(temp_classes, c)
                        end
                    end
                    on_job_done()
                end)
            end, function()
                -- 3. Save the data and UNLOCK the indexer
                M.all_classes = temp_classes
                M.is_indexing = false
                vim.notify(
                    "Global Java Index Built! Found " .. #M.all_classes .. " unique classes.",
                    vim.log.levels.INFO
                )
            end)
        end

        for _, uri in ipairs(project_uris) do
            local cmd = {
                command = "java.project.getClasspaths",
                arguments = { uri, options },
            }

            client.request("workspace/executeCommand", cmd, function(err2, resp)
                if not err2 and resp and resp.classpaths then
                    for _, path in ipairs(resp.classpaths) do
                        if path:match("%.jar$") and not unique_archives[path] then
                            unique_archives[path] = true
                            table.insert(archives_list, path)
                        end
                    end
                end

                pending_requests = pending_requests - 1
                if pending_requests == 0 then
                    finalize_indexing()
                end
            end, 0)
        end
    end, 0)
end

function M.open_picker()
    -- Safely handle attempts to open the picker while indexing or unindexed
    if #M.all_classes == 0 then
        if M.is_indexing then
            vim.notify("Still building Java index, please wait a moment...", vim.log.levels.WARN)
        else
            M.build_index()
            vim.notify("Starting Java indexer... Run the search again in a few seconds.", vim.log.levels.INFO)
        end
        return
    end

    Snacks.picker({
        title = "Java Dependencies",
        items = M.all_classes,
        layout = { preset = "default", preview = false },
        format = function(item, picker)
            return {
                { " ", "DiagnosticInfo" },
                { item.name, "Normal" },
                { "  (" .. item.pkg .. ")", "Comment" },
            }
        end,
        transform = function(item, ctx)
            if ctx and ctx.filter and ctx.filter.search then
                local query = ctx.filter.search:lower()
                local class_name = item.name:lower()

                item.score = item.score or 0
                if class_name == query then
                    item.score = item.score + 1000
                elseif class_name:find("^" .. query) then
                    item.score = item.score + 500 - #class_name
                end
            end
            return item
        end,
        confirm = function(picker, item)
            picker:close()
            if not item then
                return
            end

            local clients = vim.lsp.get_clients({ name = "jdtls" })
            if #clients == 0 then
                return
            end

            clients[1].request("workspace/symbol", { query = item.name }, function(err, result)
                if err or not result or #result == 0 then
                    return
                end

                local target_loc = nil
                for _, sym in ipairs(result) do
                    if sym.name == item.name and sym.containerName == item.pkg then
                        target_loc = sym.location
                        break
                    end
                end

                target_loc = target_loc or result[1].location

                vim.schedule(function()
                    vim.lsp.util.jump_to_location(target_loc, "utf-8", true)
                end)
            end, 0)
        end,
    })
end

return M
