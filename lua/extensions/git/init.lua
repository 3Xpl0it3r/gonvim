local M = {}

local current_project = "extensions"

M.history = function()
	require(current_project .. ".git.history.init").execute()
end

M.status = function()
	require(current_project .. ".git.status.init").execute()
end

M.diff = function()
	require(current_project .. ".git.diff").execute()
end

M.quit = function()
	require(current_project .. ".git.diff").quit()
end

M.branch = function()
	require(current_project .. ".git.branch.init").execute()
end

return M
