local M = {}

function M.sources()
	return {
		rust = require("user.null-ls.code-actions.rust").sources(),
		golang = require("user.null-ls.code-actions.golang").sources(),
		markdown = require("user.null-ls.code-actions.markdown").sources(),
	}
end

return M
