local M = {}

function M.exists(file)
	if os.rename(file, file) then
		return true
	end
	return false
end

function M.read_dir(dir) end

function M.read_file(file_name)
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
