local ls = require("luasnip")
-- some shorthands...
local func = ls.function_node
local postfix = require("luasnip.extras.postfix").postfix

local M = {
	postfix(".len", {
		func(function(_, snip)
			return "len(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
		end, {}),
	}),
}

return M
