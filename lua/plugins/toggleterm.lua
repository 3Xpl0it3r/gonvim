local status_ok, config = pcall(require, "toggleterm")
if not status_ok then
	require("utils.notify").notify("Plugin toggleterm is not existed", "error", "Plugin")
	return
end

local M = {}

local function config_toggleterm(toggleterm)
	toggleterm.setup({
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			else
				return 20
			end
		end,
		open_mapping = [[<c-\>]],
		hide_numbers = true,
		shade_filetypes = {},
		shade_terminals = false,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		-- direction = "float",
		close_on_exit = true,
		shell = vim.o.shell,
		auto_scroll = true,
		float_opts = {
			border = "single",
			winblend = 3,
		},
		winbar = {
			enable = true,
			name_formatter = function(term)
				return term.name
			end,
		},
	})
end

function _G.toggleterm_wrapper_lazygit()
	-- lazygit
	local __Terminal = require("toggleterm.terminal").Terminal
	local lazygit = __Terminal:new({
		cmd = "lazygit",
		dir = "git_dir",
		direction = "float",
		float_opts = {
			border = "single",
		},
		-- function to run on opening the terminal
		-- function to run on closing the terminal
	})
	lazygit:toggle()
end

function _G.toggleterm_wrapper_ranger()
	local __Terminal = require("toggleterm.terminal").Terminal
	local ranger = __Terminal:new({
		cmd = "ranger",
		direction = "float",
		float_opts = {
			border = "single",
		},
	})
	ranger:toggle()
end

function M.setup()
	config_toggleterm(config)
end

return M
