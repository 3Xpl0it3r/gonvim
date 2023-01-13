local M = {}


local parsers = require "nvim-treesitter.parsers"
local function get_root()
    local parser = parsers.get_parser()
    if parser == nil then
        return nil
    end

    return parser:parse()[1]:root()
end

local function get_named_node(parent, named)
    for node, name in parent:iter_children() do
        if name == named then
            return node
        end

        -- some languages have deeply nested structures
        -- in "declarator" parts can exist as well
        if name == "declarator" then
            return get_named_node(node, named)
        end
    end
end

local function get_node_information(node)
    local function_name_node = get_named_node(node, "name")
    if function_name_node == nil then
        return nil
    end

    local function_name = vim.treesitter.query.get_node_text(function_name_node, 0)

    local line_content = vim.treesitter.query.get_node_text(node, 0)

    function_name = function_name or line_content

    local row, _, _ = node:start()
    local line_number = row + 1

    return { line_number = line_number, function_name = function_name }
end

local function get_function_list_of_parent(parent)
    local content = {}

    if parent == nil then
        return content
    end

    for tsnode in parent:iter_children() do
        local is_simple_function = tsnode:type() == "function_declaration" or
            tsnode:type() == "function_definition" or
            tsnode:type() == "local_function" or
            tsnode:type() == "method_definition" or
            tsnode:type() == "method_declaration" or
            tsnode:type() == "constructor_declaration"

        if is_simple_function then
            local info = get_node_information(tsnode)
            table.insert(content, info)
        end
    end

    return content
end


function M.shell_command_toggle_wrapper(cus_cmd)
    local __Terminal = require("toggleterm.terminal").Terminal
    local cmd_termal = __Terminal:new({
        cmd = cus_cmd .. '&& read -n 1 -s  "[Press Key to continue]" && exec true',
        direction = "float",
        float_opts = {
            border = "single",
            close_on_exit = true,
            clear_env = false,
        }
    })
    cmd_termal:toggle()
end

function M.get_current_functions()
    local root = get_root()
    if root == nil then return {}
    end

    local ok, content = pcall(get_function_list_of_parent, root)
    if not ok then
        print("Something went wrong in the current buffer")
        print("Current buffer might have unsuported language or syntax")
        return {}
    end

    -- sort content, it could have different order in some edge cases
    table.sort(content, function(a, b) return a.line_number < b.line_number end)

    local funcs = {}

    table.insert(funcs, "ALL  - for all functions")

    for _, item in ipairs(content) do
        table.insert(funcs, item["function_name"])
    end


    return funcs
end

return M
