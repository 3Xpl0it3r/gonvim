local M = {}

local list_contains = function(list, expected)
	for _, value in ipairs(list) do
		if value == expected then
			return true
		end
	end
	return false
end

M.auto_import_all_modules = function(scan_path, require_prefix, black_list)
	for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. scan_path, [[v:val =~ '\.lua$']])) do
		if not list_contains(black_list, file) then
			if string.sub(require_prefix, -1) == "." then
				require_prefix = string.sub(require_prefix, 1, -2)
			end
			require(require_prefix .. "." .. file:gsub("%.lua$", ""))
		end
	end
end

M.auto_load_all_modules_that_ret_list = function(scan_path, require_prefix, black_list)
	local result = {}
	for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. scan_path, [[v:val =~ '\.lua$']])) do
		if not list_contains(black_list, file) then
			if string.sub(require_prefix, -1) == "." then
				require_prefix = string.sub(require_prefix, 1, -2)
			end
			for _, value in ipairs(require(require_prefix .. "." .. file:gsub("%.lua$", ""))) do
				table.insert(result, value)
			end
		end
	end
	return result
end

M.auto_load_all_modules_that_ret_dict = function(scan_path, require_prefix, black_list)
	local result = {}
	for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. scan_path, [[v:val =~ '\.lua$']])) do
		if not list_contains(black_list, file) then
			if string.sub(require_prefix, -1) == "." then
				require_prefix = string.sub(require_prefix, 1, -2)
			end
			for key, value in pairs(require(require_prefix .. "." .. file:gsub("%.lua$", ""))) do
				result[key] = value
			end
		end
	end
	return result
end

return M
