local M = {}

local ts_action = require("telescope.actions")
local ts_action_state = require("telescope.actions.state")

M.toggle_multi_selection = function(bufnr)
	return function()
		ts_action.toggle_selection(bufnr)
		ts_action.move_selection_next(bufnr)
	end
end

M.get_selected_items = function(bufnr)
	local results = {}
	local action_state = require("telescope.actions.state")
	local picker = action_state.get_current_picker(bufnr)
	local multi = picker:get_multi_selection()
	local num_selections = table.getn(multi)
	if num_selections <= 0 then
		local selection = action_state.get_selected_entry()
		return { selection }
	else
		for _, j in pairs(multi) do
			table.insert(results, j)
		end
	end

	return results
end

-- opts, this finder should be set through opts
M.new_resetable_finder = function(finder, opts)
	opts = opts or {}
	opts.prompt_title = vim.F.if_nil(opts.prompt_title, "Prompt")
	opts.result_title = vim.F.if_nil(opts.result_title, "Result")
	return setmetatable(opts, {
		__call = function(self, ...)
			if self._finder ~= nil then
				self._finder = nil
			end
			self._finder = finder()
			self._finder(...)
		end,
		__index = function(self, k)
			if rawget(self, "_finder") then
				local finder_val = self._finder[k]
				if finder_val ~= nil then
					return finder_val
				end
			end
		end,
	})
end

M.refresh_picker = function(bufnr)
	local current_picker = ts_action_state.get_current_picker(bufnr)
	vim.cmd([[ redraw ]])
	current_picker:refresh(current_picker.finder)
end

return M
