local M = {}

function M.sources()
	return {
		rust = require("lsp.null-ls.code-actions.rust").sources(),
		golang = require("lsp.null-ls.code-actions.golang").sources(),
	}
end

return M
