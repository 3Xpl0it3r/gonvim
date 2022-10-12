local status_ok, _ = pcall(require, "gitsigns")
if not status_ok then
    require("utils.notify").notify("Plugin gitsigns is not existed", "error", "Plugin")
    return
end

local M = {}

local function config_gitsigns(config)
    config.setup({
        signs = {
            add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
            change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
            delete = { hl = "GitSignsDelete", text = "│", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
            topdelete = { hl = "GitSignsDelete", text = "│", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
            changedelete = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
            interval = 1000,
            follow_files = true,
        },
        keymaps = {
            -- Default keymap options
            noremap = true,
            ["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
            ["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },

            --[[ ["n <leader>gs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
            ["v <leader>gs"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ["n <leader>gu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
            ["n <leader>gr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
            ["v <leader>gr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ["n <leader>gR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
            ["n <leader>gp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
            ["n <leader>gb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
            ["n <leader>gS"] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
            ["n <leader>gU"] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>', ]]

            -- Text objects
            ["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
            ["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = true,
        },
        current_line_blame_formatter_opts = {
            relative_time = false,
        },
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000,
        preview_config = {
            -- Options passed to nvim_open_win
            border = "single",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
        yadm = {
            enable = false,
        },
    })
end

function M.setup()
    local gitsigns = require("gitsigns")
    config_gitsigns(gitsigns)
end

return M
