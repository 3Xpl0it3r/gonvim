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

local lsp_format = vim.lsp.buf.format

local M = {

	snip({ trig = "fnnil" }, {
		text("fn "),
		insert(1, "FuncName"),
		text("("),
		insert(2, "Args..."),
		text({ "){", "" }),
		text({ '\tunimplemented!("unimplemented");', "" }),
		text("}"),
		insert(0),
	}, {
		callbacks = {
			[0] = {
				[events.enter] = function(node, _event_args)
					lsp_format({
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			},
		},
	}),

	snip({ trig = "fnret" }, {
		text("fn "),
		insert(1, "FuncName"),
		text("("),
		insert(2, "Args..."),
		text(") -> "),
		insert(3, "RetType"),
		text({ "{", "" }),
		text({ '\tunimplemented!("unimplemented");', "" }),
		text({ "}" }),
		insert(0),
	}, {
		callbacks = {
			[0] = {
				[events.enter] = function(node, _event_args)
					lsp_format({
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			},
		},
	}),

	snip({ trig = "pfnnil" }, {
		text("pub fn "),
		insert(1, "FuncName"),
		text("("),
		insert(2, "Args..."),
		text({ "){", "" }),
		text({ '\tunimplemented!("unimplemented");', "" }),
		text("}"),
		insert(0),
	}, {
		callbacks = {
			[0] = {
				[events.enter] = function(node, _event_args)
					lsp_format({
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			},
		},
	}),

	snip({ trig = "pfnret" }, {
		text("pub fn "),
		insert(1, "FuncName"),
		text("("),
		insert(2, "Args..."),
		text(") -> "),
		insert(3, "RetType"),
		text({ "{", "" }),
		text({ '\tunimplemented!("unimplemented");', "" }),
		text({ "}" }),
		insert(0),
	}, {
		callbacks = {
			[0] = {
				[events.enter] = function(node, _event_args)
					lsp_format({
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			},
		},
	}),

	snip({ trig = "fntest" }, {
		text({ "#[test]", "" }),
		text("fn "),
		insert(1, "TestFnName"),
		text({ "(){", "" }),
		text({ '\tunimplemented!("unimplemented");', "" }),
		text("}"),
		insert(0),
	}, {
		callbacks = {
			[0] = {
				[events.enter] = function(node, _event_args)
					lsp_format({
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			},
		},
	}),

	snip({ trig = "typs", docstring = "struct Name{\n\tField:\tType\n}", dscr = "生成一个结构体" }, {
		func(function(args, snip, _)
			return "// " .. args[1][1] .. "[#TODO] (shoule add some comments )"
		end, { 1 }, nil),
		text({ "", "" }),
		text({ "struct " }),
		insert(1, "Name"),
		text({ " {", "" }),
		text("\t"),
		insert(2, "Field"),
		text(":\t"),
		insert(3, "Type"),
		text({ "", "}" }),
		insert(0),
	}, {
		callbacks = {
			[0] = {
				[events.enter] = function(node, _event_args)
					lsp_format({
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			},
		},
	}),

	snip({
		trig = "impl_self",
		docstring = 'impl StructName {\n\tfn new() -> Self {\n\t\tunreachable!("impl this");\n\t}\n}',
		dscr = "实现方法",
	}, {
		func(function(args, snip, _)
			return "// " .. args[1][1] .. "[#TODO] (should add some comments)"
		end, { 1 }, nil),
		text({ "", "" }),
		text({ "impl " }),
		insert(1, "Name"),
		text({ " {", "" }),
		text({ "\tfn new() -> Self {", "" }),
		text({ '\t\tunreachable!("impl this")', "" }),
		text({ "\t}", "" }),
		text({ "}" }),
		insert(0),
	}, {
		callbacks = {
			[0] = {
				[events.enter] = function(node, _event_args)
					lsp_format({
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			},
		},
	}),

	snip({
		trig = "impl_for",
		docstring = "impl TraitName for StructName {\n\t\n}",
		dscr = "实现方法",
	}, {
		func(function(args, snip, _)
			return "// " .. args[1][1] .. "[#TODO] (should add some comments)"
		end, { 1 }, nil),
		text({ "", "" }),
		text({ "impl " }),
		insert(1, "TraitName"),
		text({ " for " }),
		insert(2, "StructName"),
		text({ " {", "" }),
		text({ "" }),
		text({ "}" }),
		insert(0),
	}, {
		callbacks = {
			[0] = {
				[events.enter] = function(node, _event_args)
					vim.lsp.buf.code_action({
						command = "rust-analyzer.codeAction.executeCommand",
						arguments = {
							title = "rust-analyzer: Implement missing members",
						},
					})
					lsp_format({
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			},
		},
	}),

	-- generate a test mod
	snip({
		trig = "modtest",
		docstring = '#[cfg(test)]\nmod tests{\n\tuse super::*;\n\t#[test]\n\tfn basics(){\n\t\tunreachable!("impl it");\n\t}\n}',
		dscr = "创建test mod",
	}, {
		text({ "#[cfg(test)]", "" }),
		text({ "mod tests{", "" }),
		text({ "\tuse super::*;", "" }),
		text({ "\t#[test]", "" }),
		text({ "\tfn basics(){", "" }),
		text({ '\t\tunreachable!("impl it")', "" }),
		text({ "\t}", "" }),
		text("}"),
		insert(0),
	}, {
		callbacks = {
			[0] = {
				[events.enter] = function(node, _event_args)
					lsp_format({
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			},
		},
	}),
}

return M
