local M = {}
local g_utils_path = require("utils.path")

local l_utils = require("extensions.git.utils")

function M.execute()
	local title = "Select Version Diff With (" .. l_utils.git_get_current_branch() .. ")"
	local git_root = l_utils.git_root()
	local all_branch = require("extensions.git.diff.utils").all_branchs()

	local relative = g_utils_path.format_relative(vim.api.nvim_buf_get_name(0), git_root)

	vim.ui.select(all_branch, { prompt = title }, function(version)
		if version == nil then
			return
		end
		local versioned_f = l_utils.git_temp_versioned_file(relative, version)

		l_utils.vim_diff_begin(relative, versioned_f)
	end)
end

-- exit diff mode, and then close all window that in `diff` mode
function M.quit()
	l_utils.vim_diff_end()
end

return M
