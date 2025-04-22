local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    require("utils.notify").notify("Plugin lspconfig is not existed", "error", "Plugin")
    return
end

local M = {}



local function config_lspconfig(handler)
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = "rounded"
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    local opts = {
        on_attach = handler.on_attach(),
        capabilities = handler.capabilities(),
    }

    -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
    for server_name, server_config in pairs(require("user.lsp")) do
        local opts_clone = opts
        if server_config.server == "clangd" then
            opts_clone.capabilities.offsetEncoding = { "utf-16" }
        end
        opts_clone = vim.tbl_deep_extend("force", server_config, opts)
        lspconfig[server_name].setup(opts_clone)
    end

    require("lspconfig.ui.windows").default_options.border = "rounded"
end

function M.setup()
    local handler = require("plugins/lsp/handler")
    handler.setup()
    config_lspconfig(handler)
end

return M
