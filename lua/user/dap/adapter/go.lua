local M = {}

local path = require("utils.path")
local notify_utils = require("utils.notify")
local lsputil = require("lspconfig/util")

--[[ local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values ]]

local get_mod_name = function(root_dir)
	local mod_abs = root_dir .. "/go.mod"
	local file = io.open(mod_abs, "r")
	if file then
		local content = file:read("*a")
		file:close()

		-- 使用正则表达式匹配mod后面的名称
		local moduleName = string.match(content, "module%s+(%S+)")
		if moduleName == "main" then
			return nil
		end
		return moduleName
	else
		return nil
	end
end

local get_buffer_list = function()
	local results = {}
	local root_dir = lsputil.root_pattern("go.work", "go.mod", ".git")(vim.fn.getcwd()) .. "/"
	local buffers = vim.api.nvim_list_bufs()
	for _, buffer in ipairs(buffers) do
		if vim.api.nvim_buf_is_loaded(buffer) then
			local filename = vim.api.nvim_buf_get_name(buffer)
			if string.find(filename, "%w.go$") then
				local relative_fname = (filename:sub(0, #root_dir) == root_dir) and filename:sub(#root_dir + 1)
					or filename
				table.insert(results, relative_fname)
			end
		end
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
					if choice == nil or choice == "" then
						return
					end
					local root_dir = lsputil.root_pattern("go.work", "go.mod", ".git")(vim.fn.getcwd()) .. "/"
					local execute_file = root_dir .. choice
					coroutine.resume(dap_run_co, execute_file)
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
				local pkgs = path.read_file("go.debug")
				if pkgs == nil or #pkgs == 0 then
					vim.ui.input({ prompt = "[Dap] Input Package Name" }, function(pkg_name)
						if pkg_name ~= nil and pkg_name ~= "" then
							local full_path = vim.fn.resolve(vim.fn.getcwd() .. "/" .. pkg_name)
							if path.exists(full_path) ~= true then
								notify_utils.notify("Package " .. pkg_name .. " is not existed", "error", "[Dap: Go]")
							end
							return
						else
							pkg_name = "."
						end
						coroutine.resume(dap_run_co, pkg_name)
					end)
				else
					vim.ui.select(pkgs, { prompt = "[Dap] Select Package Name" }, function(choice)
						if choice ~= nil and choice ~= "" then
							choice = "./" .. choice
						else
							choice = "."
						end
						notify_utils.notify(choice, "info", "debug go mod")
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
		program = function()
			-- got prject root abs dirname ; eg /home/l0calh0st/gopath/project1
			local root_dir = vim.lsp.buf.list_workspace_folders()[1]
			-- got subpath
			local relative = string.gsub(vim.fn.expand("%:p:h"), root_dir, "")
			-- got mod name from go.mod, eg :example.com
			local mod_name = get_mod_name(root_dir)
			if mod_name == nil then
				return relative
			end
			return mod_name .. relative
		end,
	},
}

return M
