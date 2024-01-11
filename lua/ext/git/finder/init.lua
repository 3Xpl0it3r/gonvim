local M = {}

local finders = require("telescope.finders")

local util_string = require("utils.string")

M.git_status_finder = function(results)
	return finders.new_table({
		results = results,
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

-- results = { {cmt_id, auther, date}}
M.git_show_commits = function(results)
	return finders.new_table({
		results = results,
		entry_maker = function(entry)
			-- entry [hash_id, auth_name, auth_date]
			local display = string.format("%-10s %-16s %+10s", util_string.format(entry[1], 8, "."), entry[3], entry[2])
			return {
				value = entry,
				ordinal = entry[1],
				display = display,
			}
		end,
	})
end

return M
