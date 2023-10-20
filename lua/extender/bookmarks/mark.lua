local M = {}

local format_notify = require("utils.notify")
local file_utils = require("utils.files")
local dbfile = ".bookmarks.json"

local NotifyTitle = "BookMarks"

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
		if cache["register"][annotation] ~= nil then
			format_notify.notify("Bookmark: " .. annotation .. " has Existed", "error", NotifyTitle)
			return
		end

		-- the number of must be less than 10
		if #cache["free"] == 0 then
			format_notify.notify("Bookmark: Number of bookmarks must be less than 10", "error", NotifyTitle)
			return
		end

		local mark = table.remove(cache["free"], 1)
		table.insert(cache["alloc"], mark)
		cache["register"][annotation] = mark
		vim.cmd("normal! m" .. mark)

		-- update storage
		vim.fn.JsonDumpF(reg_file, cache)
	end)
end

function M.delete()
	local reg_file = vim.lsp.buf.list_workspace_folders()[1] .. "/" .. dbfile
	if file_utils.file_exists(reg_file) == false then
		M.init()
		format_notify("BookMarks is Empty", "warn", NotifyTitle)
	end

	local cache = vim.fn.JsonLoadF(reg_file)

	local mark_anno_list = {}
	for anno, key in pairs(cache["register"]) do
		table.insert(mark_anno_list, anno)
	end

	vim.ui.select(mark_anno_list, { prompt = "Select Marks to delete" }, function(choice)
		-- if not chose mark to delete ,then return do nothing
		if not choice then
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
	end)
end

function M.list()
	local reg_file = vim.lsp.buf.list_workspace_folders()[1] .. "/" .. dbfile
	if file_utils.file_exists(reg_file) == false then
		M.init()
		format_notify("BookMarks is Empty", "warn", NotifyTitle)
	end

	local cache = vim.fn.JsonLoadF(reg_file)

	local mark_anno_list = {}
	for anno, mark in pairs(cache["register"]) do
		local col, row, _, bfname = unpack(vim.api.nvim_get_mark(mark, {}))
		table.insert(mark_anno_list, anno .. " | (" .. col .. "." .. row .. ") filename: " .. bfname)
	end

	vim.ui.select(mark_anno_list, { prompt = "All BookMarks" }, function(choice)
		-- if not chose mark to delete ,then return do nothing
		if not choice then
			return
		end
		-- delete marks from cache
	end)
end

function M.jump()
	local reg_file = vim.lsp.buf.list_workspace_folders()[1] .. "/" .. dbfile
	if file_utils.file_exists(reg_file) == false then
		M.init()
		format_notify("BookMarks is Empty", "warn", NotifyTitle)
	end

	local cache = vim.fn.JsonLoadF(reg_file)

	local mark_anno_list = {}
	for anno, mark in pairs(cache["register"]) do
		table.insert(mark_anno_list, anno)
	end

	vim.ui.select(mark_anno_list, { prompt = "Jump Bookmark" }, function(choice)
		-- if not chose mark to delete ,then return do nothing
		if not choice then
			return
		end
		-- delete marks from cache
		local mark = cache["register"][choice]

		vim.cmd("normal! '" .. mark)
	end)
end

function M.clean_all()
	local reg_file = vim.lsp.buf.list_workspace_folders()[1] .. "/" .. dbfile
	if file_utils.file_exists(reg_file) == true then
		os.remove(reg_file)
	end
end

return M
