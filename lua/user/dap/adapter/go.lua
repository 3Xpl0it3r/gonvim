local M = {}

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

--[[ M.adapters_back = function(callback, config)
	local stdout = vim.loop.new_pipe(false)
	local handle
	local pid_or_err
	local port = 38697

	local opts = {
		stdio = { nil, stdout },
		args = { "dap", "-l", "127.0.0.1:" .. port },
		detached = true,
		initialize_timeout_sec = 60,
	}
	-- this place should add some extra command to
	if config.mode == "test" then
        table.insert(opts.args, config.command_args)
    end
	handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
		stdout:close()
		handle:close()
		if code ~= 0 then
			print("dlv exited with code", code)
		end
	end)
	assert(handle, "Error running dlv: " .. tostring(pid_or_err))
	stdout:read_start(function(err, chunk)
		assert(not err, err)
		if chunk then
			vim.schedule(function()
				require("dap.repl").append(chunk)
			end)
		end
	end)
	vim.defer_fn(function()
		callback({ type = "server", host = "127.0.0.1", port = port })
	end, 100)
end ]]

M.adapters = {
	type = "server",
	port = "${port}",
	executable = {
		command = "dlv",
		args = { "dap", "-l", "127.0.0.1:${port}" },
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
