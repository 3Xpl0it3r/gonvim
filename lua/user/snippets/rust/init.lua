local M = {}

local _path = "/lua/user/snippets/rust/"
local _require_prefix = "user.snippets.rust."

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. _path, [[v:val =~ '\.lua$']])) do
	if not string.find(string.lower(file), "init.lua") then
		for _, snippets in ipairs(require(_require_prefix .. file:gsub("%.lua$", ""))) do
			table.insert(M, snippets)
		end
	end
end
return M
