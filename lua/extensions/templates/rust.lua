local M = {}

local lsputil = require("lspconfig/util")

local get_project_name = function()
    local root_dir = lsputil.root_pattern("Cargo.toml", ".git")(vim.fn.getcwd())
    local project_name = vim.fn.fnamemodify(root_dir, ":t")
    return project_name
end

M.get_template = function()
    return "// Copyright " ..
        os.date("*t")["year"] .. " " .. get_project_name() .. " Project Authors. Licensed under Apache-2.0."
end


return M
