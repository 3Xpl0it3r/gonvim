local M = {}

-- 基本上主流的lsp都已经内置,如果你想要尝试其他的lsp 只需要下面修改成你想要尝试的lsp就可以
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
