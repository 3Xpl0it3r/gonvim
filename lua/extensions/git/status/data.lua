local M = {}



-- execute git status
M.status = function()
	local gs = vim.fn.system("git status -s 2> /dev/null")
	-- items = {m={,,,}, d={,,,,}}
	local items = {}
	for s in gs:gmatch("[^\r\n]+") do
		if s == nil or s == "" then
			goto continue
		end
		local status = ""
		for w in s:gmatch("%S+") do
			if w == "A" then
				status = "A"
			elseif w == "D" then
				status = "D"
			elseif w == "M" then
				status = "M"
			elseif w == "??" then
				status = "U"
			else
				if status ~= "" then
					table.insert(items, { status, w })
				end
			end
		end
		::continue::
	end
	return items
end


return M
