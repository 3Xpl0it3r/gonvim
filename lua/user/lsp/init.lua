local notify = require("utils.notify") -- used to trigger an error message when lsp config occure an error

local M = {}

-- 基本上主流的lsp都已经内置,如果你想要尝试其他的lsp 只需要下面修改成你想要尝试的lsp就可以
local lsp_config = {
	lua = "lua_ls",
	cpp = "clangd",
	go = "gopls",
	rust = "rust_analyzer",
	java = "jdtls",
	python = "jedi_language_server",
	csharp = "omnisharp",
    markdown = "marksman",
}

local all_providers =
	require("utils.modules").auto_load_all_modules_that_ret_dict("/lua/user/lsp/providers", "user.lsp.providers.", {})

for _, lsp_name in pairs(lsp_config) do
	if all_providers[lsp_name] ~= nil then
		M[lsp_name] = all_providers[lsp_name]
	end
end

return M
