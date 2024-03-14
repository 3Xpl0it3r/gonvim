local ls = require("luasnip")
-- some shorthands...
local func = ls.function_node
local postfix = require("luasnip.extras.postfix").postfix
-- some shorthands...
-- local dynamic = ls.dynamic_node

local M = {
	postfix(".option", {
		func(function(_, snip)
			return "Option<" .. snip.snippet.env.POSTFIX_MATCH .. ">"
		end, {}),
	}),
	postfix(".some", {
		func(function(_, snip)
			return "Some(" .. snip.snippet.env.POSTFIX_MATCH .. ")"
		end, {}),
	}),
}

return M
