local M = {}

local utils_telescope = require("utils.telescope")

local git_utils = require("ext.git.utils")

local telescope_config = require("telescope.config").values
local telescope_pickers = require("telescope.pickers")
local telescope_actions = require("telescope.actions")
local telescope_action_state = require("telescope.actions.state")

local git_finders = require("ext.git.finder.init")
local git_previewers = require("ext.git.previewer.init")

-- some ops refrence branch
M.branch = function()
	local opts = {
		layout_config = {
			prompt_position = "top",
			preview_width = 0.5,
		},
	}

	local all_branch = git_utils.git_list_branchs()

	local picker = telescope_pickers.new(opts, {
		prompt_title = "Git Branchs",
		finder = git_finders.git_branchs(),
		sorter = telescope_config.generic_sorter(opts),
		previewer = git_previewers.git_inspect_branch(),
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
