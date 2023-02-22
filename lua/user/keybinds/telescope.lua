local M = {}

M.defaults_key_mapping = {
	i = {
		["<Enter>"] = require("telescope.actions").select_default,
		["<C-t>"] = require("telescope.actions").select_tab,
		["<C-v>"] = require("telescope.actions").select_vertical,
		-- ["<esc>"] = require("telescope.actions").close,
	},
	n = {
		["<esc>"] = require("telescope.actions").close,
	},
}

M.find_files_key_mapping = {
	i = {
		["Enter"] = require("telescope.actions").select_default,
		["<C-t>"] = require("telescope.actions").select_tab,
		["<C-v>"] = require("telescope.actions").select_vertical,
		-- ["<esc>"] = require("telescope.actions").close,
	},
	n = {
		["<esc>"] = require("telescope.actions").close,
	},
}

M.live_grep_key_mapping = {
	i = {
		["Enter"] = require("telescope.actions").select_default,
		["<C-t>"] = require("telescope.actions").select_tab,
		["<C-v>"] = require("telescope.actions").select_vertical,
		-- ["<esc>"] = require("telescope.actions").close,
	},
	n = {
		["<esc>"] = require("telescope.actions").close,
	},
}

return M
