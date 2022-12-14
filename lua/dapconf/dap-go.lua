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

function M.config(dap)
	dap.adapters.go = function(callback, config)
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
        local options = { initialize_timeout_sec = 60 },
		-- Wait for delve to start
		vim.defer_fn(function()
			callback({ type = "server", host = "127.0.0.1", port = port , options = options})
		end, 1000)
	end
	-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
	dap.configurations.go = {
		{
			type = "go",
			name = "Debug",
			request = "launch",
            cwd = '${workspaceFolder}',
            args = function()
                return coroutine.create(function(dap_run_co)
                    vim.ui.input({prompt="Program arguments: ", completion="file", highlight=function ()
                       return {fg="blue", bg="white"} 
                    end}, function(input)
                        coroutine.resume(dap_run_co, vim.fn.split(input, " ", true))
                    end)
                end)
            end,
			program = function()
                return coroutine.create(function(dap_run_co)
                    local items = get_buffer_list()
                    vim.ui.select(items, { prompt = 'Path to executable: '}, function(choice)
                        coroutine.resume(dap_run_co, choice)
                    end)
                end)
            end,
		},
		{
			type = "go",
			name = "Debug test", -- configuration for debugging test files
			request = "launch",
            cwd = '${workspaceFolder}',
			mode = "test",
			args = function()
                return coroutine.create(function(dap_run_co)
                    vim.ui.input({prompt="Program arguments: ", completion="file"}, function(input)
                        coroutine.resume(dap_run_co, vim.fn.split(input, " ", true))
                    end)
                end)
			end,
			program = function()
                return coroutine.create(function(dap_run_co)
                    local items = get_buffer_list()
                    vim.ui.select(items, { prompt = 'Path to executable: '}, function(choice)
                        coroutine.resume(dap_run_co, choice)
                    end)
                end)
            end,
		},
		-- works with go.mod packages and sub packages
		{
			type = "go",
			name = "Debug test (go.mod)",
			request = "launch",
            cwd = '${workspaceFolder}',
			mode = "test",
			args = function()
                return coroutine.create(function(dap_run_co)
                    vim.ui.input({prompt="Program arguments: ", completion="file"}, function(input)
                        coroutine.resume(dap_run_co, vim.fn.split(input, " ", true))
                    end)
                end)
			end,
			program = function()
                return coroutine.create(function(dap_run_co)
                    local items = get_buffer_list()
                    vim.ui.select(items, { prompt = 'Path to executable: '}, function(choice)
                        coroutine.resume(dap_run_co, choice)
                    end)
                end)
            end,
		},
	}
end

return M
