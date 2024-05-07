local status_ok, _ = pcall(require, "neotest")
if not status_ok then
    require("utils.notify").notify("neotest not found!", "error", "Plugin")
    return
end

local M = {}

M.setup = function()
    require("neotest").setup({
        adapters = {
            require("neotest-rust")({
                args = { "--no-capture" },
                dap_adapter = "rust",
            }),
        },
    })
end

return M
