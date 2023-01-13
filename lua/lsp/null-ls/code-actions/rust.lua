local null_ls_utils = require("lsp.null-ls.utils")
local format_notify = require("utils.notify")

local M = {}

local action_cargo_add = function()
	vim.ui.input({ prompt = "Input Crate Name You want to search" }, function(input)
		if input == nil or input == "" then
			format_notify.notify("code actions [cargo add] canceled input", "info", "null-ls")
			return
		end
		local result = vim.fn.CrateSearch(input)
		if result == vim.NIL then
			format_notify.notify("code actions [cargo add], cargo_api_search failed", "error", "null-ls")
			return
		end
		vim.ui.select(result, { prompt = "Select Crate" }, function(crate_name)
			if not crate_name then
				return
			end

			result = vim.fn.CrateQuery(crate_name)
			if result == vim.NIL then
				return
			end
			--[[ vim.ui.select(result, { prompt = "select version" }, function(crate_version)
				if not crate_version then
					return
				end

				require("utils.notify").notify(crate_version, "info", "select")
			end) ]]

			-- null_ls_utils.shell_command_toggle_wrapper("cargo add " .. crate_choice)

			-- vim.cmd("LspRestart")
		end)
	end)
end

local action_cargo_build = function()
	null_ls_utils.shell_command_toggle_wrapper("cargo build")
end

function M.sources()
	return {
		method = require("null-ls").methods.CODE_ACTION,
		filetypes = { "rust", "go" },
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
				}
			end,
		},
	}
end

return M
