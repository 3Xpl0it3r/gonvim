local M = {}

local utils_json = require("utils.json")
local notify_utils = require("utils.notify")
local telescope_action_state = require("telescope.actions.state")
local telescope_action_utils = require("telescope.actions.utils")

M.git_root = function()
	local git_root = vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'| tr -d ' '")

	if string.sub(git_root, -1) ~= "/" then
		git_root = git_root .. "/"
	end

	return git_root
end

M.git_get_current_branch = function()
	return vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
end

-- return {"branch1", "branch2"}
M.git_list_branchs = function()
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

M.git_temp_versioned_file = function(source_file, version)
	-- get file extension (aks file type)
	local file_ext = ""
	if string.find(source_file, ".") then
		file_ext = string.match(source_file, ".(%w+)$")
	end
	-- get conent of versioned
	local content = vim.fn.system("git show " .. version .. ":" .. source_file)
	-- generate temp file to save versiond:source_file
	local tfname = os.tmpname()
	local fname = tfname .. "." .. file_ext
	os.rename(tfname, fname)

	local tp_fhandler = io.open(fname, "w")
	if tp_fhandler == nil then
		return false
	end
	tp_fhandler:write(content)
	tp_fhandler:close()

	return fname
end

M.vim_diff_begin = function(diff_source, diff_target, recover)
	-- recover = {filename="", view=""}
	local key = "git_diff_metadata"
	if recover == nil then
		recover = { file = diff_source, view = vim.fn.winsaveview() }
	end

	local tb_meta = { diff_source = diff_source, diff_target = diff_target, recover = recover }

	-- json_util.dump(state_file, cur_state)
	vim.cmd("diffsplit  " .. diff_target)

	-- save some state into currnent tab cache
	vim.api.nvim_tabpage_set_var(0, key, tb_meta)

	utils_json.dump("testa", tb_meta)
end

M.vim_diff_end = function()
	local key = "git_diff_metadata"
	local ok, tb_meta = pcall(vim.api.nvim_tabpage_get_var, 0, key)
	if not ok then
		return
	end

	local recover = tb_meta["recover"]
	local recover_file = recover["file"]

	vim.cmd("tabedit " .. recover_file)
	ok, _ = pcall(vim.fn.winrestview, recover["view"])

	for tbid, tbnr in ipairs(vim.api.nvim_list_tabpages()) do
		-- found the relative tabpage then close it
		local ok, tv = pcall(vim.api.nvim_tabpage_get_var, tbnr, key)
		if ok and tv["diff_source"] == tb_meta["diff_source"] then
			vim.cmd(tostring(tbid) .. "tabclose")
			break
		end
	end

	ok, _ = pcall(os.remove, tb_meta["diff_target"])
end

M.telescope_multi_selection = function()
	local prompt_bufnr = vim.api.nvim_get_current_buf()
	local results = {}
	telescope_action_utils.map_entries(prompt_bufnr, function(entry, index, row)
		results[row] = entry.value
	end)
	return results
end

return M
