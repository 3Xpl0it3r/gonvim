local M = {}

function M.sources()
	return {
		rust = require("user.null-ls.code-actions.rust").sources(),
		golang = require("user.null-ls.code-actions.golang").sources(),
	}
end

return M
