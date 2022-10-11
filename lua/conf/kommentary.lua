local status_ok, _ = pcall(require, "kommentary")
if not status_ok then
    require("utils.notify").notify("Plugin kommentary is not existed", "error", "Plugin")
    return
end


local M = {}


local function config_kommentary(config)
    config.configure_language("default", {
        ignore_whitespace = true,
    })

    config.configure_language("go", {
        single_line_comment_string = "//",
        multi_line_comment_strings = { "/*", "*/" },
        prefer_multi_line_comments = true,
    })

    config.configure_language("rust", {
        single_line_comment_string = "//",
        multi_line_comment_strings = { "/*", "*/" },
        prefer_multi_line_comments = true,
    })

end

local function config_keymap()
    vim.api.nvim_set_keymap("n", "?", "<Plug>kommentary_line_default", {})
    vim.api.nvim_set_keymap("v", "?", "<Plug>kommentary_visual_default<C-c>", {})
end

function M.setup()
    config_kommentary(require("kommentary.config"))
    config_keymap()
end

return M
