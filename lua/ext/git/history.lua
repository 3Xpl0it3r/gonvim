local M = {}

local gitcommand = require("ext.git.command")
local git_previewers = require("ext.git.previewer.init")
local git_finers = require("ext.git.finder.init")

local telescope_config = require("telescope.config").values
local telescope_pickers = require("telescope.pickers")

function M.init()
	local opts = {
		layout_config = {
			prompt_position = "top",
			preview_width = 0.5,
		},
	}
	local all_cmts = gitcommand.list_all_commits()
	telescope_pickers
		.new(opts, {
			prompt_title = "Commit Search",
			finder = git_finers.git_show_commits(all_cmts),
			sorter = telescope_config.generic_sorter(opts),
			previewer = git_previewers.git_show_commit(),
		})
		:find()
end

return M
