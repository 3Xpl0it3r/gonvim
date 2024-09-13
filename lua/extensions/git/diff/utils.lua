local M = {}
M.all_branchs = function()
	-- local raw_conent = vim.fn.system("git branch -l 2> /dev/null | tr -d '\n'")
	local raw_conent = vim.fn.system("git branch -a 2> /dev/null | tr -d '\n'")
	local branchs = {}

	for b in string.gmatch(raw_conent, "%S+") do
		if string.find(b, "%*") then
			b = b:gsub("%*", "")
		end
		if string.find(b, "->") then
			goto continue
		end
		table.insert(branchs, b)
		::continue::
	end
	return branchs
end

return M
