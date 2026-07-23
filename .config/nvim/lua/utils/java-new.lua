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

        vim.ui.input({ prompt = "Name: " }, function(name)
            if not name or name == "" then
                return
            end

            local pkg = java_package_from_path(dir)
            local pkg_line = pkg and ("package " .. pkg .. ";") or ""

            local tpl_path = TEMPLATES_DIR .. choice.file
            local lines = vim.fn.readfile(tpl_path)

            for i, line in ipairs(lines) do
                line = line:gsub("{{PACKAGE}}", pkg_line)
                line = line:gsub("{{NAME}}", name)
                lines[i] = line
            end

            local filepath = dir .. "/" .. name .. ".java"
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
