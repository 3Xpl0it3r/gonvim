local M = {}

function M.sources()
	return {
		rust = require("user.null-ls.formaters.rust").source,
	}
end

return M
