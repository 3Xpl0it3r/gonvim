local ls = require("luasnip")
-- some shorthands...
local func = ls.function_node
local postfix = require("luasnip.extras.postfix").postfix
-- some shorthands...
-- local dynamic = ls.dynamic_node

local M = {
	--[[ postfix(".tostring", {
		func(function(_, snip)
			return "len(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
		end, {}),
	}), ]]
}

return M
