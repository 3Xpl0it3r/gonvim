local M = {}

local telescope_actions = require("telescope.actions")

M.toggle_multi_selection = function(bufnr)
	return function()
		telescope_actions.toggle_selection(bufnr)
		telescope_actions.move_selection_next(bufnr)
	end
end

M.get_multi_selection = function(bufnr)
	local results = {}
	local action_state = require("telescope.actions.state")
	local picker = action_state.get_current_picker(bufnr)
	local multi = picker:get_multi_selection()
	for _, j in pairs(multi) do
		table.insert(results, j)
	end
	return results
end

return M
