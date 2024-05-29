local M = {}

local ts_config = require("telescope.config").values
local ts_picker = require("telescope.pickers")
local ts_action = require("telescope.actions")
local ts_action_state = require("telescope.actions.state")

local g_utils_path = require("utils.path")

local ext_git_pkg = "extensions.git"
local l_utils = require(ext_git_pkg .. ".utils")
local finders = require(ext_git_pkg .. ".status.finder")
local previwers = require(ext_git_pkg .. ".status.previewer")

local g_utils_telescope = require("utils.telescope")

function M.execute()
	local opts = {
		layout_config = {
			prompt_position = "top",
			preview_width = 0.5,
		},

		finder = g_utils_telescope.new_resetable_finder(finders.finder),
	}

	local picker = ts_picker.new(opts, {
		prompt_title = "Git Status",
		sorter = ts_config.generic_sorter(opts),
		previewer = previwers.previewer(),
		attach_mappings = function(prompt_bufnr, mapfn)
			mapfn("n", "d", function() -- diff
				ts_action.close(prompt_bufnr)
				local git_root = l_utils.git_root()
				local selection = ts_action_state.get_selected_entry()
				local cmp_src = selection["value"][2]
				-- save current state
				local recover = {
					file = g_utils_path.format_relative(vim.api.nvim_buf_get_name(0), git_root),
					view = vim.fn.winsaveview(),
				}
				-- open the file that need to diff
				vim.cmd("e " .. selection["value"][2])
				local cmp_tgt = l_utils.git_temp_versioned_file(cmp_src, l_utils.git_get_current_branch())
				l_utils.vim_diff_begin(cmp_src, cmp_tgt, recover)
			end)

			mapfn("n", "a", function() -- add file into track
				local result = g_utils_telescope.get_selected_items(prompt_bufnr)
				for _, item in ipairs(result) do
					if item["ordinal"] == "U" then
						-- notify_utils.notify("git add ".. item["value"][2], "info", "hehe")
						vim.fn.system("git add " .. item["value"][2])
					end
					if item["ordinal"] == "D" then
						vim.fn.system("git restore " .. item["value"][2])
					end
				end
				g_utils_telescope.refresh_picker(prompt_bufnr)
			end)

			mapfn("n", "u", function() -- untrack
				local seleted = g_utils_telescope.get_selected_items(prompt_bufnr)
				for _, item in ipairs(seleted) do
					if item["ordinal"] ~= "U" then
						vim.fn.system("git rm -r --cached " .. item["value"][2])
					end
				end
				g_utils_telescope.refresh_picker(prompt_bufnr)
			end)

			mapfn("i", "<tab>", g_utils_telescope.toggle_multi_selection(prompt_bufnr))
			mapfn("i", "<CR>", function()
				local result = g_utils_telescope.get_multi_selection(prompt_bufnr)
			end)
			mapfn("n", "<CR>", function()
				local result = g_utils_telescope.get_multi_selection(prompt_bufnr)
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
