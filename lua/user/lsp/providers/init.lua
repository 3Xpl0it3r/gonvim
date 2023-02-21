local M = {}


for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/user/lsp/providers", [[v:val =~ '\.lua$']])) do
	if not string.find(string.lower(file), "init.lua") then
		M = vim.tbl_deep_extend("force", M, require("user.lsp.providers." .. file:gsub("%.lua$", "")))
	end
end

return M
