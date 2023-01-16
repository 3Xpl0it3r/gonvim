local null_ls_utils = require("conf.lsp.null-ls.utils")
local format_notify = require("utils.notify")

local M = {}

local action_cargo_add = function()
	vim.ui.input({ prompt = "Input Crate Name You want to Install" }, function(crate_name)
		if crate_name == nil or crate_name == "" then
			format_notify.notify("code actions [cargo add] canceled input", "info", "null-ls")
			return
		end
		local result = vim.fn.CrateQuery(crate_name)
		if result == vim.NIL then
			format_notify.notify("result is empty", "info", "null-ls")
			return
		end
		local crate_version_list = {}
		for version, _ in pairs(result) do
			table.insert(crate_version_list, version)
		end

		vim.ui.select(crate_version_list, { prompt = "Select Crate" }, function(crate_version)
			if not crate_version then
				return
			end

			local cmd_add_crate = string.format("cargo add %s@%s %s", crate_name, crate_version, result[crate_version])

			null_ls_utils.shell_command_toggle_wrapper(cmd_add_crate)
		end)
	end)
end

local action_crate_query = function()
	vim.ui.input({ prompt = "Input Crate Name You want to search" }, function(crate_name)
		if crate_name == nil or crate_name == "" then
			format_notify.notify("code actions [cargo add] canceled input", "info", "null-ls")
			return
		end
		local result = vim.fn.CrateSearch(crate_name)
		if result == vim.NIL then
			format_notify.notify("code actions [cargo add], cargo_api_search failed", "error", "null-ls")
			return
		end

		vim.ui.select(result, { prompt = "Search Result" }, function(crate_version)
			if not crate_version then
				return
			end
		end)
	end)
end

local action_cargo_build = function()
	null_ls_utils.shell_command_toggle_wrapper("cargo build")
end

function M.sources()
	return {
		method = require("null-ls").methods.CODE_ACTION,
		filetypes = { "rust" },
		generator = {
			fn = function(_)
				return {
					{
						title = "Cargo Add",
						action = action_cargo_add,
					},
					{
						title = "Cargo Build",
						action = action_cargo_build,
					},
					{
						title = "Cargo Run",
						action = action_cargo_build,
					},
					{
						title = "Crate Search",
						action = action_crate_query,
					},
				}
			end,
		},
	}
end

return M
