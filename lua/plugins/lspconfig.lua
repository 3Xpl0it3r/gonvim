local M = {}

local function config_lspconfig(handler)
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = "rounded"
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    local on_attach = handler.on_attach()
    local capabilities = handler.capabilities()

    -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
    for lsp_name, lsp_config in pairs(require("user.lsp")) do
        vim.lsp.config(lsp_name, { settings = lsp_config.settings, on_attach = on_attach, capabilities = capabilities })
        vim.lsp.enable(lsp_name)
    end

    require("lspconfig.ui.windows").default_options.border = "rounded"
end


function M.setup()
    local handler = require("plugins/lsp/handler")
    handler.setup()
    config_lspconfig(handler)
end

return M
