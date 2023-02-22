local M = {}

local _path = "/lua/user/snippets"

local _require_prefix = "user.snippets."

local languages = {}

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. _path)) do
	if vim.fn.isdirectory(vim.fn.stdpath("config") .. _path .. "/" .. file) ~= 0 then
		table.insert(languages, file)
	end
end

for _, language in ipairs(languages) do
	M[language] = require("utils.modules").auto_load_all_modules(
		"/lua/user/snippets/" .. language,
		"user.snippets." .. language,
		{}
	)
end

return M
