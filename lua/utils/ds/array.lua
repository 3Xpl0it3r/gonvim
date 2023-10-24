local M = {}

function M.contains(list, expected)
	for _, value in ipairs(list) do
		if value == expected then
			return true
		end
	end
	return false
end

-- mock quque
function M.queue_pop(list)
	if #list == 0 then
		return nil
	end
	return table.remove(list, 1)
end

function M.empty(list)
	return #list == 0
end

function M.queue_push(list, value)
	table.insert(list, value)
end

function M.delete(list, value)
	for index, v in ipairs(list) do
		if value == v then
			table.remove(list, index)
		end
	end
end

return M
