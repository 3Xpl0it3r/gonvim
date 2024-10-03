local M = {}

local attach_to_module = function(file_name, mod_name)
    if mod_name == "mod" then
        return
    end
    local patterns = {
        "^%bmod%s+%w+%s*;$",
        "^%bpub%s+mod%s+%w+%s*;$",
        "^%bpub%s*%(%s*crate%s*%)%s+mod%s+%w+%s*;$"
    }
    local mod_existed_pattern = "^%s*(public%s*%(%(%w+%)%s*%)mod%s+" .. mod_name .. "%s*;)"
    local lines = {}
    local pos = 1;
    local _account = 1;
    local fp, err = io.open(file_name, "r")
    if err == nil and fp ~= nil then
        local is_license = true
        while true do
            local line = fp:read()
            if line == nil then
                break
            end
            table.insert(lines, line)
            _account = _account + 1
            if line:find(mod_existed_pattern) then
                goto exit
            end
            for _, pattern in ipairs(patterns) do
                if line:find(pattern) then
                    pos = _account
                    goto continue
                end
            end
            if is_license == true and line:match("^//") == false then
                is_license = false
            end

            if is_license then
                pos = _account
            end
        end
        ::continue::
        fp:close()
    end

    table.insert(lines, pos, "pub mod " .. mod_name .. ";")

    fp, err = io.open(file_name, "w")
    if fp == nil or err ~= nil then
        require("utils.notify").notify("Cannot Open " .. file_name, "error", "NeoTree AddEvent")
        do return end
    end

    for _, line in ipairs(lines) do
        fp:write(line, "\n")
    end
    fp:flush()

    ::exit::
    fp:close()
end



local deattach_from_module = function(mod_file, mod_name)
    if mod_name == "mod" then
        return
    end
    local patterns = {
        "^%bmod%s+" .. mod_name .. "%s*;$",
        "^%bpub%s+mod%s+" .. mod_name .. "%s*;$",
        "^%bpub%s*%(%s*crate%s*%)%s+mod%s+" .. mod_name .. "%s*;$"
    }
    local lines = {}
    local fp, err = io.open(mod_file, "r")

    if err == nil and fp ~= nil then
        while true do
            local line = fp:read()
            if line == nil then
                break
            end
            for _, pattern in ipairs(patterns) do
                if line:find(pattern) then
                    goto continue
                end
            end
            table.insert(lines, line)
            ::continue::
        end
        fp:close()
    end

    fp, err = io.open(mod_file, "w")
    if fp == nil or err ~= nil then
        require("utils.notify").notify("Cannot Open " .. mod_file, "error", "NeoTree AddEvent")
        do return end
    end

    for _, line in ipairs(lines) do
        fp:write(line, "\n")
    end
    fp:flush()
    fp:close()

    vim.cmd("wincmd l")
    if vim.api.nvim_buf_get_name(0) == mod_file then
        vim.api.nvim_command("checktime " .. mod_file)
    end
end

M.on_added = function(file_name)
    --
    local mod_file = vim.fn.fnamemodify(file_name, ':p:h') .. "/mod.rs"
    local mod_name = vim.fn.fnamemodify(file_name, ":t:r")
    attach_to_module(mod_file, mod_name)
end


M.on_delete = function(file_name)
    local mod_file = vim.fn.fnamemodify(file_name, ':p:h') .. "/mod.rs"
    local mod_name = vim.fn.fnamemodify(file_name, ":t:r")
    deattach_from_module(mod_file, mod_name)
end


M.on_rename = function()

end


return M
