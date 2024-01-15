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

local utils_telescope = require("utils.telescope")

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

local delete_buffer = function(prompt_bufnr)
	local current_picker = telescope_action_state.get_current_picker(prompt_bufnr)
	local row = current_picker:get_selection_row()
	local index = current_picker:get_index(row)

	if index == #current_picker.finder.results then
		telescope_actions.move_selection_previous(prompt_bufnr)
	else
		telescope_actions.move_selection_next(prompt_bufnr)
	end

	table.remove(current_picker.finder.results, index)
	vim.api.nvim_buf_set_lines(current_picker.results_bufnr)
end

local delete_selected = function(prompt_bufnr)
	local picker = telescope_action_state.get_current_picker(prompt_bufnr)

	-- Remove all multi selections.
	-- TODO There's probably an easier way to do this?
	--      Couldn't find any API for this
	for row = 0, picker.max_results - 1 do
		local entry = picker.manager:get_entry(picker:get_index(row))
		if entry then
			notify_utils.notify(vim.inspect(entry), "info", "hehe")
			picker:remove_selection(row)
		end
	end
end

function M.status()
	local opts = {
		layout_config = {
			prompt_position = "top",
			preview_width = 0.5,
		},
	}

	local mul_select = {}

	local picker = telescope_pickers.new(opts, {
		prompt_title = "Git Status",
		finder = git_finers.git_status_finder(gitcommand.status()),
		sorter = telescope_config.generic_sorter(opts),
		previewer = git_previewers.git_diff_local(),
		attach_mappings = function(prompt_bufnr, mapfn)
			mapfn("n", "d", function() -- diff
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

			mapfn("n", "a", function() -- add file into track
				local result = utils_telescope.get_multi_selection(prompt_bufnr)
				telescope_actions.close(prompt_bufnr)
				for _, item in ipairs(result) do
					if item["ordinal"] == "U" then
						vim.fn.system("git add " .. item["value"][2])
					end
					if item["ordinal"] == "D" then
						vim.fn.system("git restore " .. item["value"][2])
					end
				end
			end)

			mapfn("n", "u", function() -- untrack
				local result = utils_telescope.get_multi_selection(prompt_bufnr)
				telescope_actions.close(prompt_bufnr)
				for _, item in ipairs(result) do
					if item["ordinal"] ~= "U" then
					end
				end
			end)

			mapfn("i", "<tab>", utils_telescope.toggle_multi_selection(prompt_bufnr))
			mapfn("i", "<CR>", function()
				local result = utils_telescope.get_multi_selection(prompt_bufnr)
				notify_utils.notify(vim.inspect(result), "error", "Txt")
			end)
			mapfn("n", "<CR>", function()
				local result = utils_telescope.get_multi_selection(prompt_bufnr)
				notify_utils.notify(vim.inspect(result), "error", "Txt")
			end)

			mapfn("n", "<ESC>", function() -- close
				telescope_actions.close(prompt_bufnr)
			end)
			return true
		end,
	})

	picker:find()
end

return M
