local ls = require "luasnip"
-- some shorthands...
local snip = ls.snippet
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamic = ls.dynamic_node
local events = require "luasnip.util.events"
local snip_node = ls.snippet_node


local M = {
    snip(
        { trig = "funcnil" },
        {
            text("fn "), insert(1, "FuncName"), text("("), insert(2, "Args..."), text({ "){", "" }),
            text("\t"),
            text({ "unimplemented!(\"unimplemented\");", "" }),
            text("}"), insert(0),
        },
        {
            callbacks = {
                [0] = {
                    [events.enter] = function(node, _event_args) vim.lsp.buf.formatting() end,
                }
            }
        }
    ),
    snip(
        { trig = "funcret" },
        {
            text("fn "), insert(1, "FuncName"), text("("), insert(2, "Args..."), text(") -> "), insert(3, "RetType"),
            text({ "{", "" }),
            text("\t"),
            text({ "unimplemented!(\"unimplemented\");", "" }),
            text({ "}" }), insert(0)
        },
        {
            callbacks = {
                [0] = {
                    [events.enter] = function(node, _event_args) vim.lsp.buf.formatting() end,
                }
            }
        }
    ),
}

return M
