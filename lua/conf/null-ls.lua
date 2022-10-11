local status_ok, _ = pcall(require, "null-ls")
if not status_ok then
    require("utils.notify").notify("Plugin null-ls is not existed", "error", "Plugin")
    return
end

local M = {}

local function config_null_ls(null_ls)
    local opts = {
        cmd = { "nvim" },
        debounce = 250,
        debug = false,
        default_timeout = 5000,
        diagnostic_config = nil,
        diagnostics_format = "#{m}",
        fallback_severity = vim.diagnostic.severity.ERROR,
        log_level = "warn",
        notify_format = "[null-ls] %s",
        on_attach = nil,
        on_init = nil,
        on_exit = nil,
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git", "go.mod", "Cargo.toml"),
        sources = nil,
        update_in_insert = false,
    }
    null_ls.setup(opts)
end

function M.setup()
    local null_ls = require("null-ls")
    for _, code_actions in pairs(require("lsp.null-ls.code-actions")) do
        null_ls.register(code_actions)
    end

    config_null_ls(null_ls)
end

return M
