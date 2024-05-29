local M = {}

local ts_finders = require("telescope.finders")
local g_utils_string = require("utils.string")

-- results = { {cmt_id, auther, date}}
M.finder = function(results)
	return ts_finders.new_table({
		results = results,
		entry_maker = function(entry)
			-- entry [hash_id, auth_name, auth_date]
			local display = string.format("%-10s %-16s %+10s", g_utils_string.format(entry[1], 8, "."), entry[3], entry[2])
			return {
				value = entry,
				ordinal = entry[1],
				display = display,
			}
		end,
	})
end

return M
