local M = {}

local python_from_env = function()
	local cwd = vim.fn.getcwd()
	if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
		return cwd .. "/venv/bin/python"
	elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
		return cwd .. "/.venv/bin/python"
	else
		return "/usr/bin/python3"
	end
end

M.adapters = function(callback, config)
	local python_path = python_from_env()
	if config.request == "attach" then
		---@diagnostic disable-next-line: undefined-field
		local port = (config.connect or config).port
		---@diagnostic disable-next-line: undefined-field
		local host = (config.connect or config).host or "127.0.0.1"
		callback({
			type = "server",
			port = assert(port, "`connect.port` is required for a python `attach` configuration"),
			host = host,
			options = {
				source_filetype = "python",
			},
		})
	else
		callback({
			type = "executable",
			command = python_path,
			args = { "-m", "debugpy.adapter" },
			options = {
				source_filetype = "python",
			},
		})
	end
end

M.configurations = {
	{
		name = "Python: Django 8000",
		type = "python",
		request = "launch",
		program = "/data/devops_backend/manage.py",
		args = { "runserver", "0.0.0.0:8000", "--noreload", "--nothreading" },
		django = "true",
		pythonPath = python_from_env(),
	},
	{
		-- The first three options are required by nvim-dap
		type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = "launch",
		name = "Launch file",

		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

		program = "${file}", -- This configuration will launch the current file if used.
		-- pythonPath = python_from_env(),
		pythonPath = python_from_env(),
	},
}

return M
