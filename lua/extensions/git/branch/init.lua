local M = {}


local ts_config_value = require("telescope.config").values
local ts_pickers = require("telescope.pickers")

local ext_git_pkg = "extensions.git"
local finders = require(ext_git_pkg .. ".branch.finder")
local previwers = require(ext_git_pkg .. ".branch.previewer")
local data = require(ext_git_pkg .. ".branch.data")

-- some ops refrence branch
M.execute = function()
	local opts = {
		layout_config = {
			prompt_position = "top",
			preview_width = 0.5,
		},
	}

	local picker = ts_pickers.new(opts, {
		prompt_title = "Git Branchs",
		finder = finders.finder(data.all_branchs()),
		sorter = ts_config_value.generic_sorter(opts),
		previewer = previwers.previwer(),
		attach_mappings = function(prompt_bufnr, mapfn)
			-- enter: for switch branch
			-- D:  for delete branch, D
			-- d: for diff current file with this branch
			-- m: move old_branch to new_branch
			-- c: change/rename old_branch to new_branch
			-- e: ediit branch Description
			-- n: create new branch according current branch
			-- N: create new branch from remote branchs
			-- <tab> for toggle many selection
			return true
		end,
	})
	picker:find()
end

return M
