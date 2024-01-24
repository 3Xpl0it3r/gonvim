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

local M = {
	------------------------------------------------
	----     Package  Statement
	------------------------------------------------
	snip({
		trig = "todo",
		dscr = "todo",
		docstring = "todo",
	}, {
		text({ "", "" }),
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
