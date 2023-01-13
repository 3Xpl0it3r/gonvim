local M = {}

function M.sources()
	return {
		rust = require("conf.lsp.null-ls.code-actions.rust").sources(),
		golang = require("conf.lsp.null-ls.code-actions.golang").sources(),
	}
end

return M
