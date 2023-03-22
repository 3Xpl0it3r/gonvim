local M = {}

M.adapters = function(callback, config) end

M.configurations = {
	{
		type = "rust",
		name = "Debug",
		request = "launch",
		cwd = "${workspaceFolder}",
	},
}

return M
