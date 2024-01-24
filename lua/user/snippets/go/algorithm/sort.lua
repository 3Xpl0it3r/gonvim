local ls = require("luasnip")
-- some shorthands...
local snip = ls.snippet
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamic = ls.dynamic_node
local events = require("luasnip.util.events")
local snip_node = ls.snippet_node

local function string_split(s, delimter)
	local result = {}
	for match in (s .. delimter):gmatch("(.-)" .. delimter) do
		table.insert(result, match)
	end
	return result
end

local M = {
	------------------------------------------------
	----     Package  Statement
	------------------------------------------------
	snip({
		trig = "trig_alg_array_find_insert",
		dscr = "二分法找找插入位置,时间复杂度位O(log^n)",
		docstring = "func searchInsert(nums []int, target int) int {\n\tleft, middle, right := 0, len(nums) >>1  , len(nums) -1\n\tfor left <= right {\n\t\tif target < nums[middle] {\n\t\t\tright = middle -1\n\t\t} else if target > nums[middle] {\n\t\t\tleft = middle + 1\n\t\t}else {\n\t\t\treturn middle\n\t\t}\n\t\tmiddle = left + ((right-left) /2  )\n\t\t}\n\treturn middle\n}",
	}, {
		text({ "func searchInsert(nums []int, target int) int {", "" }),
		text({ "\tleft, middle, right := 0, len(nums) >>1  , len(nums) -1", "" }),
		text({ "\tfor left <= right {", "" }),
		text({ "\t\tif target < nums[middle] {", "" }),
		text({ "\t\t\tright = middle -1", "" }),
		text({ "\t\t} else if target > nums[middle] {", "" }),
		text({ "\t\t\tleft = middle + 1", "" }),
		text({ "\t\t}else {", "" }),
		text({ "\t\t\treturn middle", "" }),
		text({ "\t\t}", "" }),
		text({ "\t\tmiddle = left + ((right-left) /2  )", "" }),
		text({ "\t}", "" }),
		text({ "\treturn middle", "" }),
		text({ "}" }),
	}, {
		callbacks = {
			[0] = {
				[events.enter] = function(node, _event_args)
					vim.lsp.buf.format()
				end,
			},
		},
	}),
}

return M
