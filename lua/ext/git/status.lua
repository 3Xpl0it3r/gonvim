local M = {}

local notify_utils = require("utils.notify")
local utils_path = require("utils.path")

local gitcommand = require("ext.git.command")
local git_previewers = require("ext.git.previewer.init")
local git_finers = require("ext.git.finder.init")
local git_utils = require("ext.git.utils")

local telescope_config = require("telescope.config").values
local telescope_pickers = require("telescope.pickers")
local telescope_actions = require("telescope.actions")
local telescope_action_state = require("telescope.actions.state")
local telescope_finders = require("telescope.finders")

function M.diff()
	local title = "Select Version Diff With (" .. git_utils.git_get_current_branch() .. ")"
	local git_root = git_utils.git_root()
	local all_branch = git_utils.git_list_branchs()

	local relative = utils_path.format_relative(vim.api.nvim_buf_get_name(0), git_root)

	vim.ui.select(all_branch, { prompt = title }, function(version)
		if version == nil then
			return
		end
		local versioned_f = git_utils.git_temp_versioned_file(relative, version)

		git_utils.vim_diff_begin(relative, versioned_f)
	end)
end

-- exit diff mode, and then close all window that in `diff` mode
function M.quit()
	git_utils.vim_diff_end()
end

function M.status()
	local opts = {
		layout_config = {
			prompt_position = "top",
			preview_width = 0.5,
		},
	}

	local picker = telescope_pickers.new(opts, {
		prompt_title = "Git Status",
		finder = git_finers.git_status_finder(gitcommand.status()),
		sorter = telescope_config.generic_sorter(opts),
		previewer = git_previewers.git_diff_local(),
		attach_mappings = function(prompt_bufnr, mapfn)
			mapfn("n", "d", function() -- delete bookmark
				telescope_actions.close(prompt_bufnr)
				local git_root = git_utils.git_root()
				local selection = telescope_action_state.get_selected_entry()
				local cmp_src = selection["value"][2]
				-- save current state
				local recover = {
					file = utils_path.format_relative(vim.api.nvim_buf_get_name(0), git_root),
					view = vim.fn.winsaveview(),
				}
				-- open the file that need to diff
				vim.cmd("e " .. selection["value"][2])
				local cmp_tgt = git_utils.git_temp_versioned_file(cmp_src, git_utils.git_get_current_branch())
				git_utils.vim_diff_begin(cmp_src, cmp_tgt, recover)
			end)
			return true
		end,
	})

	picker:find()
end

return M
