local M = {}

local file_utils = require("utils.files")
local notify_utils = require("utils.notify")

--[[ local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values ]]

local get_buffer_list = function()
	local results = {}
	local buffers = vim.api.nvim_list_bufs()
	for _, buffer in ipairs(buffers) do
		-- if vim.api.nvim_buf_is_loaded(buffer) then
		local filename = vim.api.nvim_buf_get_name(buffer)
		if string.find(filename, "%w.go$") then
			table.insert(results, filename)
		end
		if string.find(filename, "%w.rs$") then
			table.insert(results, filename)
		end
		if string.find(filename, "%w.py$") then
			table.insert(results, filename)
		end
		if string.find(filename, "%w.cpp$") then
			table.insert(results, filename)
		end
		-- end
	end
	return results
end

M.adapters = {
	type = "server",
	port = "${port}",
	executable = {
		command = "dlv",
		args = { "dap", "-l", "127.0.0.1:${port}", "--log" },
	},
}
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
--

M.configurations = {
	{
		type = "go",
		name = "Debug",
		request = "launch",
		cwd = "${workspaceFolder}",
		args = function()
			return coroutine.create(function(dap_run_co)
				vim.ui.input({
					prompt = "Program arguments: ",
					completion = "file",
					highlight = function()
						return { fg = "blue", bg = "white" }
					end,
				}, function(input)
					coroutine.resume(dap_run_co, vim.fn.split(input, " ", true))
				end)
			end)
		end,
		program = function()
			return coroutine.create(function(dap_run_co)
				local items = get_buffer_list()
				vim.ui.select(items, { prompt = "Path to executable: " }, function(choice)
					coroutine.resume(dap_run_co, choice)
				end)
			end)
		end,
	},

	{
		type = "go",
		name = "Debug (go.mod)",
		request = "launch",
		cwd = "${workspaceFolder}",
		args = function()
			return coroutine.create(function(dap_run_co)
				vim.ui.input({
					prompt = "Program arguments: ",
					completion = "file",
					highlight = function()
						return { fg = "blue", bg = "white" }
					end,
				}, function(input)
					coroutine.resume(dap_run_co, vim.fn.split(input, " ", true))
				end)
			end)
		end,
		program = function()
			return coroutine.create(function(dap_run_co)
				local pkgs = file_utils.readlines("go.debug")
				if pkgs == nil or #pkgs == 0 then
					vim.ui.input({ prompt = "[Dap] Input Package Name" }, function(pkg_name)
						local full_path = vim.fn.resolve(vim.fn.getcwd() .. "/" .. pkg_name)
						if file_utils.dir_exists(full_path) ~= true then
							notify_utils.notify("Package " .. pkg_name .. " is not existed", "error", "[Dap: Go]")
						end
						coroutine.resume(dap_run_co, pkg_name)
					end)
				else
					vim.ui.select(pkgs, { prompt = "[Dap] Select Package Name" }, function(choice)
						if choice ~= nil then
							choice = "./" .. choice
						end
						coroutine.resume(dap_run_co, choice)
					end)
				end
			end)
		end,
	},

	{
		type = "go",
		name = "Debug test",
		request = "launch",
		mode = "test",
		program = "${file}",
		-- extra_command_args
	},

	{
		type = "go",
		name = "Debug test (go.mod)",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
		-- extra_command_args
	},
}

return M
