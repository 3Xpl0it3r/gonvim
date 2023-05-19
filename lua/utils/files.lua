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

function M.dir_exists(dir_name)
	local ok, err, code = os.rename(dir_name .. "/", dir_name .. "/")
	if not ok then
		-- permission denied ,but it exists
		if code == 13 then
			return true
		end
	end
	return ok, err
end

function M.exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		-- permission denied ,but it exists
		if code == 13 then
			return true
		end
	end
	return ok, err
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
