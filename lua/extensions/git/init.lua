local M = {}

local current_project = "extensions"

M.history = function()
    require(current_project .. ".git.history").execute()
end

M.status = function()
    require(current_project .. ".git.status").execute()
end

M.diff = function()
    require(current_project .. ".git.diff").execute()
end

M.quit = function()
    require(current_project .. ".git.diff").quit()
end

M.branch = function()
    require(current_project .. ".git.branch").execute()
end

return M
