local ts_finders = require("telescope.finders")
-- git status
--
local data = require("extensions.git.status.data")
local M = {}

M.finder = function(result)
	return ts_finders.new_table({
		results = data.status(),
		entry_maker = function(entry)
			-- entry [hash_id, auth_name, auth_date]
			return {
				value = entry,
				display = entry[1] .. " " .. entry[2],
				ordinal = entry[1],
			}
		end,
	})
end

return M
