
local M = {}

function M.config(dap)
    -- adapters
    dap.adapters.cpp = function(callback, config)
    end
    -- config
	dap.configurations.cpp = {}
end

return M
