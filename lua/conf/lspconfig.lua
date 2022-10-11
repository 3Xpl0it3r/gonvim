local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    require("utils.notify").notify("Plugin lspconfig is not existed", "error", "Plugin")
    return
end

local M = {}


local function config_lspconfig(handler)
    local opts = {
        on_attach = handler.on_attach(),
        capabilities = handler.capabilities(),
    }

    -- Enable some language servers with the additional completion capabilities offered by nvim-cmp

    local servers = { "clangd", "pyright", "gopls", "rust_analyzer", "sumneko_lua" }
    for _, lsp in ipairs(servers) do
        -- todo debug eg print sth
        local lsp_opt = opts
        if string.match(lsp, "gopls") then
            lsp_opt = vim.tbl_deep_extend("force", require("lsp/ls/gopls"), opts)
        end
        if string.match(lsp, "clangd") then
            lsp_opt = vim.tbl_deep_extend("force", require("lsp/ls/clangd"), opts)
        end
        if string.match(lsp, "rust_analyzer") then
            lsp_opt = vim.tbl_deep_extend("force", require("lsp/ls/rust_analyzer"), opts)
        end
        if string.match(lsp, "sumneko_lua") then
            lsp_opt = vim.tbl_deep_extend("force", require("lsp/ls/lualsp"), opts)
        end

        lspconfig[lsp].setup(lsp_opt)
    end

end

function M.setup()
    local handler = require("lsp/handler")
    handler.setup()
    config_lspconfig(handler)

end

return M
