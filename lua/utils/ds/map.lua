local M = {}

function M.has_key(map, key)
	if map[key] ~= nil then
		return true
	end
	return false
end

-- return ok
function M.set(map, key, val)
	if M.has_key(map, key) then
		return false
	end
	map[key] = val
	return true
end

function M.get(map, key)
	return map[key]
end

function M.set_or_update(map, key, val)
	map[key] = val
end

function M.remove(map, key)
	for k, _ in pairs(map) do
		if k == key then
			map[key] = nil
		end
	end
end

function M.empty(map)
	return #map == 0
end

function M.keys(map)
	local keys = {}
	for key, _ in pairs(map) do
		table.insert(keys, key)
	end
	return keys
end

function M.values(map)
	local values = {}
	for _, value in pairs(map) do
		table.insert(map, value)
	end
	return values
end

function M.size(map)
	return #map
end

function M.update_key(map, old_key, new_key)
	local value = map[old_key]
	map[old_key] = nil
	map[new_key] = value
end

function M.compare(map1, map2) end

return M
