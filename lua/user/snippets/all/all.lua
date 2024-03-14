local ls = require("luasnip")

-- some shorthands...
local snip = ls.snippet
local text = ls.text_node
local func = ls.function_node
local postfix = require("luasnip.extras.postfix").postfix
local indent_snip = ls.indent_snippet_node
local sn = ls.snippet_node
local choice = ls.choice_node
local insert = ls.insert_node

local M = {

    snip(
        { trig = "date", docstring = "Date in the form of YYYY-MM-DD" },
        func(function(_, _, _)
            return { os.date("%Y-%m-%d") }
        end, {})
    ),

    snip(
        { trig = "pwd", docstring = "Path to current working directory" },
        func(function(_, _, user_args1)
            local file = io.popen(user_args1, "r")
            local res = {}
            for line in file:lines() do
                table.insert(res, line)
            end
            return res
        end, {}, { user_args = { "pwd" } })
    ),

    postfix('.wrap""', {
        func(function(_, parent)
            return '"' .. parent.snippet.env.POSTFIX_MATCH .. '"'
        end, {}),
    }),
    postfix(".wrap''", {
        func(function(_, parent)
            return "'" .. parent.snippet.env.POSTFIX_MATCH .. "'"
        end, {}),
    }),
    postfix(".wrap()", {
        func(function(_, parent)
            return "(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
        end, {}),
    }),
    postfix(".wrap[]", {
        func(function(_, parent)
            return "[" .. parent.snippet.env.POSTFIX_MATCH .. "]"
        end, {}),
    }),

    postfix(".wrap{}", {
        func(function(_, parent)
            return "{" .. parent.snippet.env.POSTFIX_MATCH .. "}"
        end, {}),
    }),
    postfix(".wrap<>", {
        func(function(_, parent)
            return "<" .. parent.snippet.env.POSTFIX_MATCH .. ">"
        end, {}),
    }),
    postfix(".end", {
        func(function(_, parent)
            return parent.snippet.env.POSTFIX_MATCH
        end, {}),
    }),

    snip({ trig = "APACHE", docstring = "Copyright 2021 The l0calh0st Authors" }, {
        indent_snip(1, {
            text({
                "/*",
                "Copyright 2022 The l0calh0st Authors.",
                'Licensed under the Apache License, PROJECT_VERSION 2.0 (the "License");',
                "you may not use this file except in compliance with the License.",
                "You may obtain a copy of the License at",
                "    http://www.apache.org/licenses/LICENSE-2.0",
                "Unless required by applicable law or agreed to in writing, software",
                'distributed under the License is distributed on an "AS IS" BASIS,',
                "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.",
                "See the License for the specific language governing permissions and",
                "limitations under the License.",
                "*/",
            }),
        }, ""),
    }),
}

return M
