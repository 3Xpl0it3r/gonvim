local M = {}

function M.get_visual_selection()
	local line_st = vim.fn.line("v")
	local line_end = vim.fn.line(".")
	local lines = vim.api.nvim_buf_get_lines(0, line_st - 1, line_end, true)

	return table.concat(lines, " ")
end

return M
