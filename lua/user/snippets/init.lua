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
	M[language] = {}
	for _, submodule in
		ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. _path .. "/" .. language, [[v:val =~ '\.lua$']]))
	do
		for _, snippets in ipairs(require(_require_prefix .. language .. "." .. submodule:gsub("%.lua$", ""))) do
			table.insert(M[language], snippets)
		end
	end
end

return M
