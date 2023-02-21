local status_ok, _ = pcall(require, "which-key")
if not status_ok then
	require("utils.notify").notify("Plugin which_key is not existed", "error", "Plugin")
	return
end

local M = {}

local function config_whichkeys(which_key)
	local conf = {
		window = {
			border = "single", -- none, single, double, shadow
			position = "bottom", -- bottom, top
		},
		popup_mappings = {
			scroll_down = "<c-d>", -- binding to scroll down inside the popup
			scroll_up = "<c-u>", -- binding to scroll up inside the popup
		},
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "->", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
		layout = {
			height = { min = 4, max = 25 }, -- min and max height of the columns
			width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
			align = "left", -- align columns left, center or right
		},
		hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
		show_help = true, -- show help message on the command line when the popup is visible
		triggers = "auto", -- automatically setup triggers
		disable = {
			buftypes = {},
			filetypes = { "TelescopePrompt" },
		},
	}

	local opts_normal = {
		mode = "n", -- Normal mode
		prefix = "<leader>",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymapswhich
		nowait = false, -- use `nowait` when creating keymaps
	}

	local opts_visual = {
		mode = "v", -- Visual mode
		prefix = "<leader>",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymapswhich
		nowait = false, -- use `nowait` when creating keymaps
	}

	which_key.setup(conf)
	which_key.register(require("user.keybinds.which-keys").normal, opts_normal)
	which_key.register(require("user.keybinds.which-keys").visual, opts_visual)
end

function M.setup()
	config_whichkeys(require("which_key"))
end

return M
