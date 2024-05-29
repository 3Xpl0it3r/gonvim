local M = {}

M.all_commits = function()
	-- local ret = vim.fn.system("git log  --pretty='format:%<(8,trunc)%H %an %as%n'")
	local ret = vim.fn.system("git log  --pretty='format:%H %an %as%n'")

	local cmt_list = {}
	for item in ret:gmatch("[^\r\n]+") do
		if item == nil or item == "" then
			goto continue
		end
		local count = 0
		local tmp_arr = {}
		for s in item:gmatch("%S+") do
			if count < 3 then
				table.insert(tmp_arr, s)
				count = count + 1
			end
		end
		table.insert(cmt_list, tmp_arr)
		::continue::
	end
	return cmt_list
end

return M
