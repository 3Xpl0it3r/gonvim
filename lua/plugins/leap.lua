
local status_ok, _ = pcall(require, "leap")
if not status_ok then
    require("utils.notify").notify("Plugin leap is not existed", "error", "Plugin")
    return
end

local M = {}

local function config_leap(config)
    config.setup({
    })
end

function M.setup()
    local leap = require("leap")
    config_hop(leap)
end

return M
