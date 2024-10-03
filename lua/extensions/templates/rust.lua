local M = {}

local get_project_name = function()
    local root_dir = vim.lsp.buf.list_workspace_folders()
    if root_dir == nil or #root_dir == 0 then
        return "Default"
    end
    return root_dir[1]
end

M.tpl = "// Copyright " .. os.date("*t")["year"] .. get_project_name() .. " Project Authors. Licensed under Apache-2.0."

return M
