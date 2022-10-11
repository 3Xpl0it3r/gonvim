
local M = {}

function M.config(dap)
    -- adapters
    dap.adapters.python = function(callback, config)
    end
    -- config
	dap.configurations.python = {}
end

return M
