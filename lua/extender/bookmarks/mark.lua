local M = {}

local notifier = require("utils.notify")
local file_utils = require("utils.files")

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

-- some const values
local dbfile = ".bookmarks.json" -- Default stotage file

function M.init()
	vim.cmd("delmarks a-zA-Z")
	local bk_reg_file = vim.lsp.buf.list_workspace_folders()[1] .. "/" .. dbfile
	os.remove(bk_reg_file)
	local initial = {
		register = {},
		free = {
			"A",
			"B",
			"C",
			"D",
			"E",
			"F",
			"G",
			"H",
			"I",
			"J",
			"K",
			"L",
			"M",
			"N",
			"O",
			"P",
			"Q",
			"R",
			"S",
			"T",
			"U",
			"V",
			"W",
			"X",
			"Y",
			"Z",
		},
		alloc = {},
	}
	vim.fn.JsonDumpF(bk_reg_file, initial)
end

function M.register()
	-- if annotation existed, throw an error, don't update
	-- if annotation not existed, then add
	local reg_file = vim.lsp.buf.list_workspace_folders()[1] .. "/" .. dbfile

	if file_utils.file_exists(reg_file) == false then
		M.init()
	end

	local cache = vim.fn.JsonLoadF(reg_file)

	vim.ui.input({ prompt = "Input BookMark Annotation" }, function(annotation)
		local title = "Register BookMarks" -- Define notify tile
		local message_success = title .. " Successfully!"
		local message_failed = title .. " Failed: "

		if cache["register"][annotation] ~= nil then
			notifier.notify(message_failed .. "bookmark" .. annotation .. "has existed", notifier.Level.error, title)
			return
		end

		-- the number of must be less than 10
		if #cache["free"] == 0 then
			notifier.notify(message_failed .. "too many bookmarks", notifier.Level.warn, title)
			return
		end

		if annotation == nil then
			notifier.notify(message_failed .. "canceled", notifier.Level.warn, title)
		end

		local mark = table.remove(cache["free"], 1)
		table.insert(cache["alloc"], mark)
		cache["register"][annotation] = mark
		vim.cmd("normal! m" .. mark)

		-- update storage
		vim.fn.JsonDumpF(reg_file, cache)

		notifier.notify(message_success, notifier.Level.info, title)
	end)
end

function M.delete()
	local title = "Delete BookMarks" -- Define notify tile
	local message_success = title .. " Successfully!"
	local message_failed = title .. " Failed: "

	local reg_file = vim.lsp.buf.list_workspace_folders()[1] .. "/" .. dbfile
	if file_utils.file_exists(reg_file) == false then
		M.init()
		notifier("BookMarks is Empty", "warn", title)
	end

	local cache = vim.fn.JsonLoadF(reg_file)

	local mark_anno_list = {}
	for anno, key in pairs(cache["register"]) do
		table.insert(mark_anno_list, anno)
	end

	vim.ui.select(mark_anno_list, { prompt = "Select Marks to delete" }, function(choice)
		-- if not chose mark to delete ,then return do nothing
		if not choice then
			notifier.notify(message_failed .. "canceled", notifier.Level.warn, title)
			return
		end
		-- delete marks from cache
		local mark = cache["register"][choice]
		cache["register"][choice] = nil

		-- delete from vim register
		vim.api.nvim_del_mark(mark)

		for index, value in ipairs(cache["alloc"]) do
			if value == mark then
				table.remove(cache["alloc"], index)
			end
		end
		table.insert(cache["free"], mark)

		vim.fn.JsonDumpF(reg_file, cache)

		notifier.notify(message_success, notifier.Level.info, title)
	end)
end

function M.list()
	local title = "Delete BookMarks" -- Define notify tile
	local reg_file = vim.lsp.buf.list_workspace_folders()[1] .. "/" .. dbfile

	if file_utils.file_exists(reg_file) == false then
		M.init()
		notifier("BookMarks is Empty", "warn", title)
	end

	local cache = vim.fn.JsonLoadF(reg_file)

	local annonations = {}
	for anno, mark in pairs(cache["register"]) do
		table.insert(annonations, anno)
	end

	local opts = {}
	pickers
		.new(opts, {
			prompt_title = "List Bookmarks",
			finder = finders.new_table({
				results = annonations,
			}),
			sort = conf.generic_sorter(opts),
		})
		:find()
end

function M.jump()
	local title = "Jump BookMarks" -- Define notify tile
	local reg_file = vim.lsp.buf.list_workspace_folders()[1] .. "/" .. dbfile
	if file_utils.file_exists(reg_file) == false then
		M.init()
		notifier("BookMarks is Empty", notifier.Level.warn, title)
	end

	local cache = vim.fn.JsonLoadF(reg_file)

	local mark_anno_list = {}
	for anno, mark in pairs(cache["register"]) do
		table.insert(mark_anno_list, anno)
	end

	vim.ui.select(mark_anno_list, { prompt = "Jump Bookmark" }, function(choice)
		local message_success = title .. " Successfully!"
		local message_failed = title .. " Failed: "

		-- if not chose mark to delete ,then return do nothing
		if not choice then
			notifier.notify(message_failed .. " canceled ", notifier.Level.warn, title)
			return
		end
		-- delete marks from cache
		local mark = cache["register"][choice]

		vim.cmd("normal! '" .. mark)

		notifier.notify(message_success, notifier.Level.info, title)
	end)
end

function M.clean_all()
	local reg_file = vim.lsp.buf.list_workspace_folders()[1] .. "/" .. dbfile
	if file_utils.file_exists(reg_file) == true then
		os.remove(reg_file)
	end
end

return M
