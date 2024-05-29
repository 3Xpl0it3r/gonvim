local ts_previwers = require("telescope.previewers")

local M = {}
M.previewer = function()
	return ts_previwers.new_termopen_previewer({
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

return M
