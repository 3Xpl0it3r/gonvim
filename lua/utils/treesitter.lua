local M = {}

local parsers = require("nvim-treesitter.parsers")
local ts_utils = require("nvim-treesitter.ts_utils")

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

	local function_name = vim.treesitter.get_node_text(function_name_node, 0)

	local line_content = vim.treesitter.get_node_text(node, 0)

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
		local is_simple_function = tsnode:type() == "function_declaration"
			or tsnode:type() == "function_definition"
			or tsnode:type() == "local_function"
			or tsnode:type() == "method_definition"
			or tsnode:type() == "method_declaration"
			or tsnode:type() == "constructor_declaration"

		if is_simple_function then
			local info = get_node_information(tsnode)
			table.insert(content, info)
		end
	end

	return content
end

function M.all_available_functions()
	local root = get_root()
	if root == nil then
		return {}
	end

	local ok, content = pcall(get_function_list_of_parent, root)
	if not ok then
		print("Something went wrong in the current buffer")
		print("Current buffer might have unsuported language or syntax")
		return {}
	end

	-- sort content, it could have different order in some edge cases
	table.sort(content, function(a, b)
		return a.line_number < b.line_number
	end)

	local funcs = {}

	-- table.insert(funcs, "ALL  - for all functions")

	for _, item in ipairs(content) do
		table.insert(funcs, item["function_name"])
	end

	return funcs
end

-- this is code is copyed from https://www.reddit.com/r/neovim/comments/pd8f07/using_treesitter_to_efficiently_show_the_function/
function M.function_surrounding_cursor()
	local prev_function_node = nil
	local prev_function_name = ""

	local current_node = ts_utils.get_node_at_cursor()
	if not current_node then
		return ""
	end

	local func = current_node

	while func do
		if func:type() == "function_definition" then
			break
		end

		func = func:parent()
	end

	if not func then
		prev_function_node = nil
		prev_function_name = ""
		return ""
	end

	if func == prev_function_node then
		return prev_function_name
	end
	prev_function_node = func

	local find_name
	find_name = function(node)
		for i = 0, node:named_child_count() - 1, 1 do
			local child = node:named_child(i)
			local type = child:type()

			if type == "identifier" or type == "operator_name" then
				return (ts_utils.get_node_text(child))[1]
			else
				local name = find_name(child)

				if name then
					return name
				end
			end
		end

		return nil
	end
	local fname = find_name(func)
	if fname == nil then
		return ""
	end

	return fname
end

return M
