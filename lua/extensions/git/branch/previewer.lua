
local M = {}

local ts_previwers = require("telescope.previewers")

M.previwer = function()
	return ts_previwers.new_termopen_previewer({
		title = "Branch Info",
		-- entry is "str"
		get_command = function(entry)
			local cmd = "git log  --graph " .. entry[1]
			return cmd
		end,
	})
end

return M
