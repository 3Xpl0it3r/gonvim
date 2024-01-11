local M = {}
local utils_path = require("utils.path")

local git_utils = require("ext.git.utils")

function M.diff()
	local title = "Select Version Diff With (" .. git_utils.git_get_current_branch() .. ")"
	local git_root = git_utils.git_root()
	local all_branch = git_utils.git_list_branchs()

	local relative = utils_path.format_relative(vim.api.nvim_buf_get_name(0), git_root)

	vim.ui.select(all_branch, { prompt = title }, function(version)
		if version == nil then
			return
		end
		local versioned_f = git_utils.git_temp_versioned_file(relative, version)

		git_utils.vim_diff_begin(relative, versioned_f)
	end)
end

-- exit diff mode, and then close all window that in `diff` mode
function M.quit()
	git_utils.vim_diff_end()
end

return M
