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
    {trig = "def", dscr = "new function block"},
    {
        text("def"), insert(1, "FunName"), text("("), insert(2, "Args..."), text({"):", ""}),
        text({"\t", "\"\"\"", ""}),
        func(function ()

        end, {2}, nil),
        text({"\t", "\"\"\"", ""}),
        text({"\t", "return"})
    },
    {}
    ),
}

return M
