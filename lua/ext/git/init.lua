local M = {}

local notify_utils = require("utils.notify")

--swap file
local new_buffer_from_content = function(content, typ)
	local tp_fname = os.tmpname()
	os.rename(tp_fname, tp_fname .. "." .. typ)
	tp_fname = tp_fname .. "." .. typ
	local tp_fhandler = io.open(tp_fname, "w")
	if tp_fhandler == nil then
		return false
	end
	tp_fhandler:write(content)
	tp_fhandler:close()

	return tp_fname
end

-- some const variables
local curr_branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")

local win_is_diff_mod = function(win_nr)
	local wo = vim.wo[win_nr]
	if wo["diff"] == nil or wo["diff"] == false then
		return false
	end
	return true
end

local get_all_branch = function()
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

function M.diff()
	local title = "Select Version Diff With (" .. curr_branch .. ")"
	local git_root = vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'| tr -d ' '")
	if string.sub(git_root, -1) ~= "/" then
		git_root = git_root .. "/"
	end
	local all_branch = get_all_branch()

	local file_abs = vim.api.nvim_buf_get_name(0)
	local ftype = vim.bo.filetype
	local relative = string.gsub(file_abs, git_root, "")

	vim.ui.select(all_branch, { prompt = title }, function(version)
		if version == nil then
			return
		end
		local diff_content = vim.fn.system("git show " .. version .. ":" .. relative)
		local diff_target = new_buffer_from_content(diff_content, ftype)
		local tb_meta = { diff_src = relative, win_view = vim.fn.winsaveview(), diff_target = diff_target }

		-- json_util.dump(state_file, cur_state)
		vim.cmd("diffsplit  " .. diff_target)

		-- save some state into currnent tab cache
		vim.api.nvim_tabpage_set_var(0, "tb_meta", tb_meta)

		-- get all windows
	end)

	-- record some temp file
end

local delete_diff_win = function(win_nr)
	-- close previous tabpage

	-- switch to new tabpage
	-- delete all windows in previous tabpage
	--[[ vim.api.nvim_set_current_win(win_nr)
	local buf_nr = vim.api.nvim_get_current_buf()
	-- delete window
	vim.api.nvim_win_close(win_nr, true)
	-- delete buffer
	vim.api.nvim_buf_delete(buf_nr, { force = true }) ]]
end

-- exit diff mode, and then close all window that in `diff` mode
function M.quit()
	-- get metadata of current tabpage, if current tabpage is not diff tb, then skip
	local ok, tb_meta = pcall(vim.api.nvim_tabpage_get_var, 0, "tb_meta")
	if not ok then
		notify_utils.notify("This tabpage is not in diff mode", notify_utils.Level.warn, "Git Diff Quit")
		return
	end

	-- create new tabpage
	vim.cmd("tabnew " .. tb_meta["diff_src"])

	for _, tbnr in ipairs(vim.api.nvim_list_tabpages()) do
        -- found the relative tabpage then close it
		local ok, tv = pcall(vim.api.nvim_tabpage_get_var, tbnr, "tb_meta")
		if ok and tv["diff_src"] == tb_meta["diff_src"] then
			vim.cmd(tostring(tbnr) .. "tabclose")
			notify_utils.notify("delete tabpage " .. tostring(tbnr), notify_utils.Level.info, "Git Diff  Quit")
			break
		end
	end

	-- restore win view
	ok, _ = pcall(vim.fn.winrestview, tb_meta["win_view"])
	if not ok then
		notify_utils.notify("Restore windows snapshot failed", notify_utils.Level.error, "Git Diff Quit")
	end

	ok, _ = pcall(os.remove, tb_meta["diff_target"])
	if not ok then
		notify_utils.notify(
			"remove tmpfile " .. tb_meta["diff_target"] .. "failed",
			notify_utils.Level.error,
			"Git Diff Quit"
		)
	end
end

return M
