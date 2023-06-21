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
			changedelete = {
				hl = "GitSignsChange",
				text = "│",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
			untracked = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		},
		signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
		numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
		linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
		word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		on_attach = require("user.keybinds.gitsigns").on_attach,
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
