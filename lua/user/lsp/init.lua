local M = {}

local lsp_config = {
	lua = "lua_ls",
	cpp = "clangd",
	go = "gopls",
	rust = "rust_analyzer",
	java = "jdtls",
	python = "pyright",
	csharp = "omnisharp",
}

for _, lsp_name in pairs(lsp_config) do
	M[lsp_name] = require("user.lsp.config.init")[lsp_name]
end

return M
