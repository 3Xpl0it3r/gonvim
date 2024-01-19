local M = {}

local notify_utils = require("utils.notify")
local utils_path = require("utils.path")

local git_previewers = require("ext.git.previewer.init")
local git_finers = require("ext.git.finder.init")
local git_utils = require("ext.git.utils")

local ts_config = require("telescope.config").values
local ts_picker = require("telescope.pickers")
local ts_action = require("telescope.actions")
local ts_action_state = require("telescope.actions.state")

local utils_ts = require("utils.telescope")

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

		finder = utils_ts.new_resetable_finder(git_finers.git_status_finder),
	}

	local picker = ts_picker.new(opts, {
		prompt_title = "Git Status",
		sorter = ts_config.generic_sorter(opts),
		previewer = git_previewers.git_diff_local(),
		attach_mappings = function(prompt_bufnr, mapfn)
			mapfn("n", "d", function() -- diff
				ts_action.close(prompt_bufnr)
				local git_root = git_utils.git_root()
				local selection = ts_action_state.get_selected_entry()
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
				local result = utils_ts.get_selected_items(prompt_bufnr)
				for _, item in ipairs(result) do
					if item["ordinal"] == "U" then
						-- notify_utils.notify("git add ".. item["value"][2], "info", "hehe")
						vim.fn.system("git add " .. item["value"][2])
					end
					if item["ordinal"] == "D" then
						vim.fn.system("git restore " .. item["value"][2])
					end
				end
				utils_ts.refresh_picker(prompt_bufnr)
			end)

			mapfn("n", "u", function() -- untrack
				local seleted = utils_ts.get_selected_items(prompt_bufnr)
				for _, item in ipairs(seleted) do
					if item["ordinal"] ~= "U" then
						vim.fn.system("git rm -r --cached " .. item["value"][2])
					end
				end
				utils_ts.refresh_picker(prompt_bufnr)
			end)

			mapfn("i", "<tab>", utils_ts.toggle_multi_selection(prompt_bufnr))
			mapfn("i", "<CR>", function()
				local result = utils_ts.get_multi_selection(prompt_bufnr)
			end)
			mapfn("n", "<CR>", function()
				local result = utils_ts.get_multi_selection(prompt_bufnr)
			end)

			mapfn("n", "<ESC>", function() -- close
				ts_action.close(prompt_bufnr)
			end)
			return true
		end,
	})

	picker:find()
end

return M
