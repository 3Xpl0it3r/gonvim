local winbar_file = function()
	local file_path = vim.fn.expand("%:~:.:h")
	local filename = vim.fn.expand("%:t")
	local file_type = vim.fn.expand("%:e")
	local value = ""
	local file_icon = ""

	file_path = file_path:gsub("^%.", "")
	file_path = file_path:gsub("^%/", "")

	return value
end

local function status_line()
	local file_path = vim.fn.expand("%:~:.:h")
	local file_name = "%-.16t"
	local buf_nr = "[%n]"
	local modified = " %-m"
	local file_type = " %y"
	local right_align = "%="
	local line_no = "%10([%l/%L%)]"
	local pct_thru_file = "%5p%%"
	file_path = file_path:gsub("^%.", "")
	file_path = file_path:gsub("^%/", "")

	return string.format(
		"%s%s%s%s%s%s%s%s",
		file_path,
		file_name,
		buf_nr,
		modified,
		file_type,
		right_align,
		line_no,
		pct_thru_file
	)
end

vim.opt.statusline = status_line()
