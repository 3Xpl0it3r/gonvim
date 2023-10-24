local M = {}

function M.exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		-- permission denied ,but it exists
		if code == 13 then
			return true
		end
	end
	return ok
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
