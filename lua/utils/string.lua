local M = {}

M.format = function(str, size, fillsign)
	local strlen = vim.fn.strdisplaywidth(str)
	local fmt_str = ""
	if strlen > size then
		fmt_str = string.sub(str, 1, size)
		return fmt_str
	end
	fmt_str = str
	for _ = 1, size - strlen, 1 do
		fmt_str = fmt_str .. fillsign
	end
	return fmt_str
end

return M
