local M = {}

local ts_finders = require("telescope.finders")


M.finder = function(results)
	return ts_finders.new_table({
		results = results,
		-- results = git_utils.git_list_branchs(),
	})
end

return M
