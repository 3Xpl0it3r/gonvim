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

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp_status_ok, cmp = pcall(require, "cmp")
    if not cmp_status_ok then
        return
    end
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
end

function M.setup()
    local autopairs = require("nvim-autopairs")
    config_autopairs(autopairs)
end

return M
