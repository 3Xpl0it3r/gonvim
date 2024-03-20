local M = {}

-- cache compiler
--
-- select/set compiler
--
-- do action
local godbolt = require("ext.compiler.godbolt")
local util_buffer = require("utils.buffer")

local default_compiler_versions = {
	go = function()
		local rust_version = vim.fn.system("rustc -V")
		local token = vim.split(rust_version, " ")
		local version = string.gsub(token[2], "%.", "")
		return version
	end,
	rust = function()
		local rust_version = vim.fn.system("rustc -V")
		local token = vim.split(rust_version, " ")
		local version = string.gsub(token[2], "%.", "")
		return "r" .. version
	end,
}

function M.set_compiler()
	-- get current file type
	local langue = vim.bo.filetype
	local compilers = godbolt.compilers(langue)
	-- {v1=value1, v2=valuie2}
	local c_items = {}
	for key, _ in pairs(compilers) do
		table.insert(c_items, key)
	end
	vim.ui.select(c_items, { prompt = "Set compiler" }, function(choice)
		if choice == nil or choice == "" then
			return
		end
		require("utils.notify").notify(vim.inspect(compilers[choice]), "error", "Plugin")
		vim.api.nvim_set_var("godbolt_compile", compilers[choice])
	end)
end

function M.compile()
	local langue = vim.bo.filetype
	local action_reg = {}
	action_reg.rust = { compile = "", gen_mir = "--emit=mir", macro_expand = "-Zunpretty=expanded" }

	if action_reg[langue] == nil then
		return
	end

	local acts = {}
	for key, _ in pairs(action_reg[langue]) do
		table.insert(acts, key)
	end

	local source_code = util_buffer.get_visual_selection()
	if source_code == nil or source_code == "" then
		require("utils.notify").notify("No Source Code Selected", "error", "Compile")
		return
	end
	local existed, compiler = pcall(function()
		return vim.api.nvim_get_var("godbolt_compile")
	end)
	if not existed then
		compiler = default_compiler_versions[langue]()
		vim.api.nvim_set_var("godbolt_compile", compiler)
	end

	vim.ui.select(acts, { prompt = "Select Compile Ops" }, function(choice)
		if choice == nil or choice == "" then
			return
		end
		local opts = action_reg[langue][choice]

		-- if language is rust and actions is macro_expand, then reset compiler as "nightly" , for macro only can be exapand in nighty version
		if langue == "rust" and choice == "macro_expand" then
			compiler = "nightly"
		end
		godbolt.compile_term(compiler, source_code, opts)
	end)
end

return M
