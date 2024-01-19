local M = {}

-- curl command should in path environment
M.get = function (url)
    local cmd = "curl -s -XGET " .. url
    local resp = vim.fn.system(cmd)

    
end





return M
