local M = {}

local telescope_config = require("telescope.config").values
local telescope_pickers = require("telescope.pickers")

local ext_git_pkg = "extensions.git"

local finders = require(ext_git_pkg .. ".history.finder")
local previewers = require(ext_git_pkg .. ".history.previwer")
local data = require(ext_git_pkg .. ".history.data")

function M.execute()
	local opts = {
		layout_config = {
			prompt_position = "top",
			preview_width = 0.5,
		},
	}
	telescope_pickers
		.new(opts, {
			prompt_title = "Commit Search",
			finder = finders.finder(data.all_commits()),
			sorter = telescope_config.generic_sorter(opts),
			previewer = previewers.previewer(),
		})
		:find()
end

return M
