
local M = {}

function M.config(dap)
    -- adapters
    dap.adapters.rust = function(callback, config)
    end
    -- config
	dap.configurations.rust = {}
end

return M
