local status_ok, _ = pcall(require, "hlchunk")

if not status_ok then
	require("utils.notify").notify("hlchunk not found!", "error", "Plugin")
	return
end

local M = {}

local function config_hlchunk(hlchunk)
	local options = {
		chunk = {
			enable = true,
			use_treesitter = true,
			chars = {
				horizontal_line = "─",
				vertical_line = "│",
				left_top = "╭",
				left_bottom = "╰",
				right_arrow = ">",
			},
			style = {
				-- { fg = "#806d9c" },
                {fg = "#9CCC65"}
			},
		},
		blank = {
			enable = false,
		},
		indent = {
			enable = false,
		},
	}
	hlchunk.setup(options)
end

function M.setup()
	local hlchunk = require("hlchunk")
	config_hlchunk(hlchunk)
end

return M
