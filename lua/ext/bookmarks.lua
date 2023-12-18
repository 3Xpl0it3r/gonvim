local M = {}
local json = require("utils.json")
local notifier = require("utils.notify")
local path = require("utils.path")
local map = require("utils.ds.map")
local treesitter_utils = require("utils.treesitter")

-- import telescope
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local telescope_config = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- some const values
local cache_file = ".bookmarks.json" -- Default stotage file

local SIZE_TXT = 32
local SIZE_TYPE = 32

local init = function()
	vim.cmd("delmarks a-zA-Z")
	local reg_file = vim.lsp.buf.list_workspace_folders()[1] .. "/" .. cache_file
	os.remove(reg_file)
	local initial = {
		index = 0,
		registry = {}, -- {name={index=0, mark='A'}}
	}

	assert(json.dump(reg_file, initial), "Write BookMark Initial Data to cache file Failed")
end

function M.add()
	local title = "Register BookMarks" -- Define notify tile
	local message_success = title .. " Successfully!"
	local message_failed = title .. " Failed: "
	-- if annotation existed, throw an error, don't update
	-- if annotation not existed, then add
	local root_dir = vim.lsp.buf.list_workspace_folders()
	if root_dir == nil or #root_dir == 0 then
		notifier.notify(message_failed .. "No Lsp Found", notifier.Level.warn, title)
		return
	end
	local reg_file = root_dir[1] .. "/" .. cache_file

	if path.exists(reg_file) == false then
		init()
	end

	local registry = json.load(reg_file)
	if registry == nil then
		return
	end

	vim.ui.input({ prompt = "Input BookMark Annotation" }, function(bk_name)
		if bk_name == nil then
			return notifier.notify(message_failed .. "Cancel ", notifier.Level.info, title)
		end

		if map.has_key(registry["registry"], bk_name) then
			notifier.notify(message_failed .. "bookmark" .. bk_name .. "has existed", notifier.Level.error, title)
			return
		end

		if bk_name == nil then
			notifier.notify(message_failed .. "canceled", notifier.Level.warn, title)
		end

		-- get filename and current lines in current buffer
		local filename = vim.api.nvim_buf_get_name(0)
		local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
		local node_info = treesitter_utils.function_surrounding_cursor()

		map.set(
			registry["registry"],
			bk_name,
			{ index = registry.index, filename = filename, lnum = r, ts = node_info }
		)

		-- inc index automatically
		registry.index = registry.index + 1

		-- update storage
		-- vim.fn.JsonDumpF(reg_file, registry)
		json.dump(reg_file, registry)

		notifier.notify(message_success, notifier.Level.info, title)
	end)
end

local jump_to_file = function(filename, line)
	vim.cmd("e" .. filename)
	vim.cmd('execute  "normal! ' .. line .. 'G;zz"')
	vim.cmd('execute  "normal! zz"')
end

function M.actions()
	local title = "BookMarks" -- Define notify tile

	local root_dir = vim.lsp.buf.list_workspace_folders()
	if root_dir == nil or #root_dir == 0 then
		notifier.notify("No Lsp Found", notifier.Level.warn, title)
		return
	end
	local reg_file = root_dir[1] .. "/" .. cache_file

	if path.exists(reg_file) == false then
		init()
		notifier.notify("Cache File is not existed", "warn", title)
	end

	local registry = json.load(reg_file)
	if registry == nil then
		return
	end

	local bk_key_list = {}
	for key, _ in pairs(registry["registry"]) do
		table.insert(bk_key_list, { key })
	end

	local opts = {
		layout_config = {
			prompt_position = "top",
			preview_width = 0.5,
		},
	}
	pickers
		.new(opts, {
			prompt_title = title,
			finder = finders.new_table({
				results = bk_key_list,
				entry_maker = function(entry)
					local bk_item = map.get(registry["registry"], entry[1])

					local display = entry[1]
					if vim.fn.strdisplaywidth(entry[1]) <= SIZE_TXT then
						for _ = 1, SIZE_TXT - vim.fn.strdisplaywidth(entry[1]), 1 do
							display = display .. " "
						end
					end
					display = display .. bk_item.ts.icon .. " "
					display = display .. bk_item.ts.name

					return {
						value = entry[1],
						display = display,
						ordinal = entry[1],
						filename = bk_item.filename,
						lnum = bk_item.lnum,
					}
				end,
			}),
			sorter = telescope_config.generic_sorter(opts),
			previewer = telescope_config.qflist_previewer(opts),
			attach_mappings = function(prompt_bufnr, mapfn)
				mapfn("n", "d", function() -- delete bookmark
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()

					-- delete marks from cache
					map.remove(registry["registry"], selection.value)

					-- persistent cache storage
					assert(json.dump(reg_file, registry))
					notifier.notify(
						"Delelte Bookmark: " .. selection.value .. " Successfully",
						notifier.Level.info,
						title
					)
				end)
				mapfn("n", "r", function() -- rename bookmark
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					vim.ui.input({ prompt = "Rename BookMark" }, function(new_name)
						map.update_key(registry["registry"], selection.value, new_name)

						assert(json.dump(reg_file, registry))
					end)
				end)
				mapfn("i", "<CR>", function() -- selected and jump to bookmark
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					jump_to_file(
						registry["registry"][selection.value]["filename"],
						registry["registry"][selection.value]["lnum"]
					)
				end)
				mapfn("n", "<CR>", function() -- selected and jump to bookmark
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					jump_to_file(
						registry["registry"][selection.value]["filename"],
						registry["registry"][selection.value]["lnum"]
					)
				end)

				return true
			end,
		})
		:find()
end

function M.clean_all()
	local reg_file = vim.lsp.buf.list_workspace_folders()[1] .. "/" .. cache_file
	if path.exists(reg_file) == true then
		os.remove(reg_file)
	end
end

return M
