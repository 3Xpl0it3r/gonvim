local ts_perviewers = require("telescope.previewers")

local M = {}
M.previewer = function()
	return ts_perviewers.new_termopen_previewer({
		title = "Commit",
		get_command = function(entry)
			local diff = "git show "
			return diff .. entry["value"][1]
		end,
	})
end

return M
