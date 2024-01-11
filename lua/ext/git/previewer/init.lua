local M = {}

local previewers = require("telescope.previewers")

M.git_diff_local = function()
	return previewers.new_termopen_previewer({
		title = "Change",
		get_command = function(entry)
			local diff = "git diff "
			if entry["ordianl"] ~= "U" then
				diff = diff .. "  --no-index /dev/null "
			end
			return diff .. entry["value"][2]
		end,
	})
end

M.git_show_commit = function()
	return previewers.new_termopen_previewer({
		title = "Commit",
		get_command = function(entry)
			local diff = "git show "
			return diff .. entry["value"][1]
		end,
	})
end

return M
