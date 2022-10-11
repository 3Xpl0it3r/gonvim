local status_ok, _ = pcall(require, "telescope")
if not status_ok then
    require("utils.notify").notify("Plugin telescope is not existed", "error", "Plugin")
    return
end

local M = {}

local function config_telescope(telescope)
    local actions = require("telescope.actions")
    telescope.setup({
        defaults = {
            -- Default configuration for telescope goes here:
            -- config_key = value,
            prompt_prefix = " ",
            wrap_results = true,
            selection_caret = " ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "ascending",
            layout_strategy = "vertical",
            file_ignore_patterns = { "vendor", },
            layout_config = {
                prompt_position = "top",
            },
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            color_devicons = true,
            use_less = true,
            set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
            mappings = {
                i = {
                    ["<Enter>"] = actions.select_default,
                    ["<C-t>"] = actions.select_tab,
                    ["<C-v>"] = actions.select_vertical,
                    -- ["<esc>"] = require("telescope.actions").close,
                },
                n = {
                    ["<esc>"] = require("telescope.actions").close,
                },
            },
        },
        pickers = {
            find_files = { -- basic filename to fine files
                layout_strategy = "horizontal",
                mappings = {
                    i = {
                        ["Enter"] = require("telescope.actions").select_default,
                        ["<C-t>"] = require("telescope.actions").select_tab,
                        ["<C-v>"] = require("telescope.actions").select_vertical,
                        -- ["<esc>"] = require("telescope.actions").close,
                    },
                    n = {
                        ["<esc>"] = require("telescope.actions").close,
                    },
                },
            },
            live_grep = { -- basic context to find files
                layout_strategy = "vertical",
                mappings = {
                    i = {
                        ["Enter"] = require("telescope.actions").select_default,
                        ["<C-t>"] = require("telescope.actions").select_tab,
                        ["<C-v>"] = require("telescope.actions").select_vertical,
                        -- ["<esc>"] = require("telescope.actions").close,
                    },
                    n = {
                        ["<esc>"] = require("telescope.actions").close,
                    },
                },
            },
        },
        extensions = {
            fzf = {
                fuzzy = true, -- false wil only do exact matching
                override_generic_sorter = true, -- override then generic sorter
                override_file_sorter = true, -- override then file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            },
        },
    })
end

local function config_highlights()
    local highlights = {
        -- Sets the highlight for selected items within the picker.
        -- preview
        TelescopePreviewTitle = { fg = "#FF7433", bg = "#282828" },
        TelescopePromptTitle = { fg = "#FF7433", bg = "#282828" },
        TelescopeResultsTitle = { fg = "#FF7433", bg = "#282828" },

        TelescopeBorder = { fg = "#4FC3F7", bg = "#282828" },
        TelescopePromptBorder = { fg = "#B77BFA", bg = "#282828" },
        TelescopePreviewBorder = { fg = "#9CCC65", bg = "#282828" },
        TelescopeResultsBorder = { fg = "#4FC3F7", bg = "#282828" }
    }
    for k, v in pairs(highlights) do
        vim.api.nvim_set_hl(0, k, v)
    end
end

function M.setup()
    local telescope = require("telescope")
    config_telescope(telescope)
    config_highlights()
end

return M
