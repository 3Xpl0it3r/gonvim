local M = {}

function M.file_exists(file_nme)
	local f = io.open(file_nme, "r")
	if f ~= nil then
		io.close(file_nme)
		return true
	else
		return false
	end
end

function M.readlines(file_name)
	local lines = {}
	local file = io.open(file_name)
	if file == nil then
		return nil
	end

	while true do
		local line = file:read()
		if line == nil then
			break
		end
		table.insert(lines, line)
	end

	return lines
end

return M
