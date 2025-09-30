local M = {}

-- 基本上主流的lsp都已经内置,如果你想要尝试其他的lsp 只需要下面修改成你想要尝试的lsp就可以
local lsp_config = {
    lua = "lua_ls",
    cpp = "clangd",
    go = "gopls",
    rust = "rust_analyzer",
    python = "jedi_language_server",
    markdown = "marksman",
}

local all_lsp_configs =
    require("utils.modules").auto_load_all_modules_that_ret_dict("/lua/user/lsp/providers", "user.lsp.providers.", {})

for _, lsp_name in pairs(lsp_config) do
    if all_lsp_configs[lsp_name] ~= nil then
        M[lsp_name] = all_lsp_configs[lsp_name]
    end
end

return M
