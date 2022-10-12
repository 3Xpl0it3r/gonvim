local M = {}

local function config_notify(config)
    local opts = {
        timeout   = 1, -- Default timeout for notification
        max_width = 80, -- (number|function)    Max number of columns for messages
        level     = "info ", --      (string|integer)     Minimum log level to display. See vim.log.levels. max_height  = 1, --      (number|function)    Max number of lines for a message
        -- stages        = 1, --      (string|function[])  Animation stages
        -- background_co = 1, --lour} (string)             For stages that change opacity this is treated as the highlight behind the window. Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
        -- icons         = 1, --      (table)              Icons for each level (upper case names) {on_open}           (function)           Function called when a new window is opened, use for changing win settings/config
        -- on_close      = 1, --      (function)           Function called when a window is closed
        -- render        = "slide", --      (function|string)    Function to render a notification buffer or a built-in renderer name
        minimum_width = 40, --}     (integer)            Minimum width for notification windows
        fps       = 60, --      (integer)            Frames per second for animation stages, higher value means smoother animations but more CPU usage
        top_down  = false, --     (boolean)            whether or not to position the notifications at the top or not
    }
    config.setup(opts)
end

M.setup = function()
    config_notify(require("notify"))
end

return M
