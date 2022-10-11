local status_ok, _ = pcall(require, "bufferline")
if not status_ok then
    require("utils.notify").notify("Plugin bufferline is not existed", "error", "Plugin")
    return
end

local M = {}

local function config_bufferline(config)
    config.setup({
        options = {
            mode = "buffers", -- set to "tabs" to only show tabpages instead
            -- numbers = "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
            numbers = "both",
            close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
            right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
            left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
            middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
            -- NOTE: this plugin is designed with this icon in mind,
            -- and so changing this is NOT recommended, this is intended
            -- as an escape hatch for people who cannot bear it for whatever reason
            indicator = {
                icon = '▎', -- this should be omitted if indicator style is not 'icon'
                style = 'icon',
                -- style = 'icon' | 'underline' | 'none',
            },
            buffer_close_icon = "",
            modified_icon = "●",
            close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            --- name_formatter can be used to change the buffer's label in the bufferline.
            --- Please note some names can/will break the
            --- bufferline so use this at your discretion knowing that it has
            --- some limitations that will *NOT* be fixed.
            name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
                -- remove extension from markdown files for example
                if buf.name:match("%.md") then
                    return vim.fn.fnamemodify(buf.name, ":t:r")
                end
            end,
            max_name_length = 18,
            max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
            tab_size = 18,
            -- diagnostics = false | "nvim_lsp" | "coc",
            diagnostics = "nvim_lsp",
            diagnostics_update_in_insert = true,
            -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
                local icon = level:match("error") and " " or " "
                return " " .. icon .. count
            end,
            -- NOTE: this will be called a lot so don't do any heavy processing here
            custom_filter = function(buf_number, buf_numbers)
                -- filter out filetypes you don't want to see
                if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                    return true
                end
                -- filter out by buffer name
                if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                    return true
                end
                -- filter out based on arbitrary rules
                -- e.g. filter out vim wiki buffer from tabline in your work repo
                if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                    return true
                end
                -- filter out by it's index number in list (don't show first buffer)
                if buf_numbers[1] ~= buf_number then
                    return true
                end
            end,
            -- offsets = {{filetype = "NvimTree", text = "File Explorer" | function , text_align = "left" | "center" | "right"}},
            offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "left", highlight = "Directory" } },
            color_icons = true, -- whether or not to add the filetype icon highlights
            show_buffer_icons = true, -- disable filetype icons for buffers
            show_buffer_close_icons = true,
            show_buffer_default_icon = true, -- whether or not an unrecognised filetype should show a default icon
            show_close_icon = true,
            show_tab_indicators = true,
            persist_buffer_sort = false, -- whether or not custom sorted buffers should persist
            -- separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
            separator_style = "slant",
            enforce_regular_tabs = true,
            always_show_bufferline = true,
            -- sort_by = 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function
            sort_by = "insert_after_current",
            numbers = function(opts)
                -- return string.format('%s|%s', opts.id, opts.raise(opts.ordinal))
                return string.format("%s|%s", opts.ordinal, opts.raise(opts.id))
            end,
            left_mouse_command = function(bufnum)
                require("bufdelete").bufdelete(bufnum, true)
            end,
        },
    })
end

function M.setup()
    --[[ local bufferline = require("bufferline")
    config_bufferline(bufferline) ]]
end

return M
