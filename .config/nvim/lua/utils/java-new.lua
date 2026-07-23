local function java_package_from_path(dir)
    local pkg = dir:match("src/main/java/(.+)$") or dir:match("src/test/java/(.+)$")
    if not pkg then
        return nil
    end
    pkg = pkg:gsub("/$", ""):gsub("/", ".")
    return pkg
end

local TEMPLATES_DIR = vim.fn.stdpath("config") .. "/templates/java/"

local TYPES = {
    { label = "Class", file = "class.java" },
    { label = "Interface", file = "interface.java" },
    { label = "Enum", file = "enum.java" },
    { label = "Record", file = "record.java" },
    { label = "Abstract Class", file = "abstract_class.java" },
    { label = "Annotation", file = "annotation.java" },
}

local function create_java_file(dir)
    vim.ui.select(TYPES, {
        prompt = "New Java File",
        format_item = function(item)
            return item.label
        end,
    }, function(choice)
        if not choice then
            return
        end

        vim.ui.input({ prompt = "Name: " }, function(input)
            if not input or input == "" then
                return
            end

            -- Clean input and parse dot notation (e.g., "dto.request.UserDto")
            input = input:gsub("%.java$", "")
            local parts = {}
            for part in string.gmatch(input, "[^.]+") do
                table.insert(parts, part)
            end

            local name = table.remove(parts) -- Last part is class name
            local extra_pkg = table.concat(parts, ".") -- Remaining parts form sub-packages
            local target_dir = dir

            -- Append subdirectories to the physical directory path
            if #parts > 0 then
                target_dir = target_dir .. "/" .. table.concat(parts, "/")
                vim.fn.mkdir(target_dir, "p") -- Create nested dirs if they don't exist
            end

            -- Build the final package statement
            local base_pkg = java_package_from_path(dir)
            local full_pkg = base_pkg
            if extra_pkg ~= "" then
                full_pkg = base_pkg and (base_pkg .. "." .. extra_pkg) or extra_pkg
            end

            local pkg_line = full_pkg and ("package " .. full_pkg .. ";") or ""

            local tpl_path = TEMPLATES_DIR .. choice.file
            local lines = vim.fn.readfile(tpl_path)

            for i, line in ipairs(lines) do
                line = line:gsub("{{PACKAGE}}", pkg_line)
                line = line:gsub("{{NAME}}", name)
                lines[i] = line
            end

            local filepath = target_dir .. "/" .. name .. ".java"
            vim.fn.writefile(lines, filepath)
            vim.cmd("edit " .. vim.fn.fnameescape(filepath))

            for i, line in ipairs(lines) do
                if line:match("{$") then
                    vim.api.nvim_win_set_cursor(0, { i + 1, 0 })
                    break
                end
            end
        end)
    end)
end

return {
    create_java_file = create_java_file,
}
