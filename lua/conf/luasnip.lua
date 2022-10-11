local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
    require("utils.notify").notify("Plugin luasnip is not existed", "error", "Plugin")
    return
end

local M = {}

local function config_luasnip(ls)
    local s = ls.snippet
    local sn = ls.snippet_node
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node
    local d = ls.dynamic_node
    local r = ls.restore_node
    local l = require("luasnip.extras").lambda
    local rep = require("luasnip.extras").rep
    local p = require("luasnip.extras").partial
    local m = require("luasnip.extras").match
    local n = require("luasnip.extras").nonempty
    local dl = require("luasnip.extras").dynamic_lambda
    local fmt = require("luasnip.extras.fmt").fmt
    local fmta = require("luasnip.extras.fmt").fmta
    local types = require("luasnip.util.types")
    local conds = require("luasnip.extras.expand_conditions")
    local ai = require "luasnip.nodes.absolute_indexer"
    local postfix = require "luasnip.extras.postfix".postfix
    local isn = ls.indent_snippet_node

    ls.config.set_config({
        history = true,
        update_events = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
        ext_opts = {
            [types.choiceNode] = {
                active = {
                    -- virt_text = { { "choiceNode", "TSAAAReference" } },
                },
            },
            [types.insertNode] = {
                active = {
                    -- virt_text = { { "InsertNode", "TSAAAEmphasis" } },
                },
            },
        },
        -- treesitter-hl has 100, use something higher (default is 200).
        ext_base_prio = 300,
        -- minimal increase in priority.
        ext_prio_increase = 1,
        enable_autosnippets = true,
        -- mapping for cutting selected text so it's usable as SELECT_DEDENT,
        -- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
        store_selection_keys = "<Tab>",
        ft_func = function()
            return vim.split(vim.bo.filetype, ".", true)
        end,
    })

    ls.add_snippets("all", require("snippets/all"))
    ls.add_snippets("go", require("snippets/go"))
    ls.add_snippets("rust", require("snippets/rust"))



    vim.api.nvim_set_keymap("i", "<C-s>", '<cmd>lua require("luasnip.extras.select_choice")()<cr>', {})
end

-- set keybinds for both INSERT and VISUAL.

-- set keybinds for both INSERT and VISUAL.

function M.setup()
    config_luasnip(require("luasnip"))
end

return M
