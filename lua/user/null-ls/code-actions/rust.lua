local shell = require("utils.shell")
local format_notify = require("utils.notify")

local pickers = require("telescope.pickers") -- used for build a telescope picker
local finders = require("telescope.finders") -- used for build a telescope finder
local previewers = require("telescope.previewers") -- used for build a telescope previewer
local actions = require("telescope.actions") -- used to replace default mapping for user
local action_state = require("telescope.actions.state") -- used to get select entry

local M = {}

local insert_wrapped_text = function(bufnr, items, num_lines)
	local width = vim.api.nvim_win_get_width(0) + 30

	local seperate = ""
	for _ = 1, width, 1 do
		seperate = seperate .. " "
	end

	local wrapped_lines = {}
	for index, line in ipairs(items) do
		local current_line = ""
		for word in line:gmatch("%S+") do
			if #current_line + #word + 1 > width then
				table.insert(wrapped_lines, current_line)
				current_line = ""
			end
			if #current_line == 0 then
				current_line = word
			else
				current_line = current_line .. " " .. word
			end
		end
		if #current_line > 0 then
			table.insert(wrapped_lines, current_line)
		end
		if num_lines <= 0 or index <= num_lines then
			table.insert(wrapped_lines, seperate)
		end
		-- table.insert(wrapped_lines, seperate)
	end

	vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, wrapped_lines)
end

local action_cargo_add = function()
	vim.ui.input({ prompt = "Input Crate Name You want to Install" }, function(crate_name)
		if crate_name == nil or crate_name == "" then
			format_notify.notify("code actions [cargo add] canceled input", "info", "null-ls")
			return
		end
		local result = vim.fn.CrateQuery(crate_name)
		if result == vim.NIL then
			format_notify.notify("result is empty: " .. crate_name, "info", "null-ls")
			return
		end
		local crate_version_list = {}
		for version, _ in pairs(result) do
			table.insert(crate_version_list, version)
		end

		vim.ui.select(crate_version_list, { prompt = "Select Crate" }, function(crate_version)
			if not crate_version then
				return
			end

			local cmd_add_crate = string.format("cargo add %s@%s %s", crate_name, crate_version, result[crate_version])

			shell.execute(cmd_add_crate)
			vim.cmd("LspRestart")
		end)
	end)
end

local action_crate_query = function()
	vim.ui.input({ prompt = "Input Crate Name You want to search" }, function(crate_name)
		if crate_name == nil or crate_name == "" then
			format_notify.notify("code actions [cargo add] canceled input", "info", "null-ls")
			return
		end
		local crate_items = vim.fn.CrateSearch(crate_name)
		if crate_items == vim.NIL then
			format_notify.notify("result is empty", "info", "null-ls")
			return
		end

		local opts = {
			layout_strategy = "horizontal",
			layout_config = {
				prompt_position = "top",
				preview_width = 0.6,
			},
		}

		pickers
			.new(opts, {
				prompt_title = "Input",
				results_title = "Available Crate",
				finder = finders.new_table({
					results = crate_items,
					entry_maker = function(entry)
						return {
							value = entry,
							display = entry.id,
							ordinal = entry.id,
						}
					end,
				}),
				-- sorter = conf.generic_sorter(),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry() --  获取当前选中内容
						local version_items = vim.fn.CrateQuery(selection.display)
						pickers
							.new(opts, {
								prompt_title = "Crate: " .. selection.display,
								results_title = "Versions",
								finder = finders.new_table({
									results = version_items,
									entry_maker = function(entry)
										return {
											value = entry,
											display = entry.version,
											ordinal = entry,
										}
									end,
								}),
								attach_mappings = function(prompt_bufnr, map)
									actions.select_default:replace(function()
										actions.close(prompt_bufnr)
										local entry = action_state.get_selected_entry()
										local features = ""
										for feature, _ in pairs(entry.value.features) do
											features = features .. " --features " .. feature
										end
										local cmd_add_crate = string.format(
											"cargo add %s@%s %s",
											entry.value.crate,
											entry.value.version,
											features
										)

										null_ls_utils.shell_command_toggle_wrapper(cmd_add_crate)
									end)
									return true
								end,
								previewer = previewers.new_buffer_previewer({
									title = "Details",
									define_preview = function(self, entry, status)
										local fmt = {
											string.format("Crate: %s", entry.value.crate),
											string.format("LICENSE: %s", entry.value.license),
											string.format("CrateSize: %s", entry.value.crate_size),
											string.format("CreateAt: %s", entry.value.create_at),
											string.format("UpdatedAt: %s", entry.value.updated_at),
											string.format("DownloadPath: %s", entry.value.dl_path),
											string.format("Featutes:"),
										}
										for key, feature_details in pairs(entry.value.features) do
											key = "- " .. key .. ":"
											for _, value in ipairs(feature_details) do
												key = key .. "[" .. value .. ","
											end
											key = key .. "]"
										end
										insert_wrapped_text(self.state.bufnr, fmt, 7)
									end,
								}),
							})
							:find()
					end)
					return true
				end,
				previewer = previewers.new_buffer_previewer({
					title = "Description",
					define_preview = function(self, entry, status)
						local fmt = {
							string.format("Name: %s", entry.value.id),
							string.format("Version: %s", entry.value.max_stable_version),
							string.format("Site: %s", entry.value.home),
							string.format("Document: %s", entry.value.doc),
							string.format("GitRepo: %s", entry.value.git),
							string.format("Description: %s", entry.value.description),
						}
						insert_wrapped_text(self.state.bufnr, fmt, 0)
					end,
				}),
			})
			:find()
	end)
end

local action_cargo_build = function()
	null_ls_utils.shell_command_toggle_wrapper("cargo build")
end

local action_cargo_run = function()
	vim.ui.input({ prompt = "Input Arguments" }, function(input)
		local args = ""
		if input then
			args = "-- " .. input
		end
		null_ls_utils.shell_command_toggle_wrapper("cargo run " .. args)
	end)
end

local action_cargo_test = function()
	null_ls_utils.shell_command_toggle_wrapper("cargo test -- --nocapture")
end

function M.sources()
	return {
		method = require("null-ls").methods.CODE_ACTION,
		filetypes = { "rust" },
		generator = {
			fn = function(_)
				return {
					{
						title = "Cargo Add",
						action = action_cargo_add,
					},
					{
						title = "Cargo Build",
						action = action_cargo_build,
					},
					{
						title = "Cargo Run",
						action = action_cargo_run,
					},
					{
						title = "Cargo Test",
						action = action_cargo_test,
					},
					{
						title = "Crate Manager",
						action = action_crate_query,
					},
				}
			end,
		},
	}
end

return M
