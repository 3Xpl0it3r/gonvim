local M = {}

local finders = require("telescope.finders")

local util_string = require("utils.string")

local git_utils = require("ext.git.utils")
local gitcommand = require("ext.git.command")

M.git_status_finder = function()
	local result = gitcommand.status()
	return finders.new_table({
		results = result,
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

M.git_branchs = function()
	return finders.new_table({
		results = git_utils.git_list_branchs(),
	})
end

return M
