local M = {}

M.history = function()
	require("ext.git.history").init()
end

M.status = function()
	require("ext.git.status").status()
end

M.diff = function()
	require("ext.git.diff").diff()
end

M.quit = function()
	require("ext.git.diff").quit()
end

M.branch = function()
	require("ext.git.branch").branch()
end

return M
