local M = {}

function M.new_options()
	return {
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
				{ fg = "#9CCC65" },
			},
		},
		blank = {
			enable = false,
		},
		indent = {
			enable = false,
		},
		line_num = {
			enable = false,
		},
	}
end

return M
