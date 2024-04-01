local status_ok, _ = pcall(require, "nvim-autopairs")
if not status_ok then
    require("utils.notify").notify("nvim-autopairs not found!", "error", "Plugin")
    return
end

local M = {}

local function config_autopairs(config)
    config.setup({
        check_ts = false,
        ts_config = {
            lua = { "string", "source" },
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
            map = "<M-e>",
            chars = { "{", "[", "(", '"', "'" },
            pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
            offset = 0,
            end_key = "$",
            keys = "qwertyuiopzxcvbnmasdfghjkl",
            check_comma = true,
            highlight = "PmenuSel",
            highlight_grey = "LineNr",
        },
    })

end

function M.setup()
    local autopairs = require("nvim-autopairs")
    config_autopairs(autopairs)
end

return M
