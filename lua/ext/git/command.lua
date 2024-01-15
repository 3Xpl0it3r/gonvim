local M = {}

M.branch_tree = function (branch)
end


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

M.list_all_commits = function()
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

M.get_command_git_show = function(cmt_id)
	return "git show " .. cmt_id
end

return M
