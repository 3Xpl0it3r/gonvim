local M = {}
local notifier = require("utils.notify")

local parsers = require("nvim-treesitter.parsers")
local ui_icons = require("ui.icons")

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

function M.function_surrounding_cursor()
	local current_node = vim.treesitter.get_node()

	local prev_node = current_node

	while current_node ~= true do
		if current_node:type() == "source_file" then
			break
		end
		prev_node = current_node
		current_node = current_node:parent()
	end

	if prev_node == nil then
		return { type = "", name = "", icon = "" }
	end

	local node_type = prev_node:type()
	local name = ""
	local icon = ""

	if node_type == "function_declaration" then
		name = vim.treesitter.get_node_text(prev_node:named_child(0), 0)
		icon = ui_icons.lspKind.Function
	elseif node_type == "method_declaration" then
		name = vim.treesitter.get_node_text(prev_node:named_child(1), 0)
		icon = ui_icons.lspKind.Method
	end

	return { type = node_type, name = name, icon = icon }
end

return M
