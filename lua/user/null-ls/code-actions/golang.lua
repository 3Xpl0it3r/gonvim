local format_notify = require("utils.notify")
local kubernetes = require("user.null-ls.code-actions.ecosystem.kubernetes")
local g_utils_shell = require("utils.shell")

local M = {}

local action_go_vendor = function()
	g_utils_shell.execute("go mod tidy && go mod vendor", "vertical")
	-- require("utils.notify").notify_execute_command({ "go", "mod", "vendor" })
	vim.cmd("LspRestart")
end

local action_go_gentest = function()
	vim.ui.select(
		require("utils.treesitter").all_available_functions(),
		{ prompt = "Select Function To Generate Test" },
		function(choice)
			if not choice then
				return
			end
			local current_file = vim.api.nvim_buf_get_name(0)
			if choice == "ALL  - for all functions" then
				require("utils.notify").notify_execute_command({
					"gotests",
					"-all",
					"-w",
					current_file,
				})
			else
				require("utils.notify").notify_execute_command({
					"gotests",
					"-only",
					choice,
					"-w",
					current_file,
				})
			end
		end
	)
end

local action_kubernetes_mod = function()
	vim.ui.input({ prompt = "Input Kubernetes Version" }, function(k8s_version)
		if not k8s_version then
			return
		end
		local all_k8s_mod = kubernetes.all_modes(k8s_version)
		if all_k8s_mod == vim.NIL then
			format_notify.notify("code action [Golang] fetch all k8s pkg failed", "error", "null-ls")
			return
		end

		vim.ui.select(all_k8s_mod, { prompt = "Select Package To Install" }, function(choice)
			if not choice then
				return
			end
			kubernetes.download(choice, k8s_version)
		end)
	end)
end

function M.sources()
	return {
		method = require("null-ls").methods.CODE_ACTION,
		filetypes = { "go" },
		generator = {
			fn = function(context)
				return {
					{
						title = "Select Imports",
						action = function()
							local get_pkgs = function()
								local results = {}
								local list_pkg = io.popen("gopkgs"):read("*all")
								for line in list_pkg:gmatch("[^\n\r]+") do
									table.insert(results, line)
								end
								return results
							end
							local import_position = -1
							local pkg_position = -1
							for index, value in ipairs(context["content"]) do
								local find = string.find(value, "import")
								if find then
									import_position = index
									break
								end
								if pkg_position == -1 then
									local find_pkg = string.find(value, "package")
									if find_pkg then
										pkg_position = index
									end
								end
							end
							local postion = import_position
							local no_import = false
							if postion == -1 then
								no_import = true
								postion = pkg_position
							end
							vim.ui.select(get_pkgs(), { prompt = "Import Packages" }, function(choice)
								if not choice then
									return
								end
								vim.ui.input({ prompt = "Alias PkgName" }, function(input)
									local newline = nil
									if input then
										newline = "\t" .. input .. '"' .. choice .. '"'
									else
										newline = "\t" .. '"' .. choice .. '"'
									end
									if not no_import then
										vim.api.nvim_buf_set_lines(0, postion, postion, false, { newline })
									else
										vim.api.nvim_buf_set_lines(
											0,
											postion,
											postion,
											false,
											{ "import(", newline, ")" }
										)
									end
									-- vim.lsp.buf.format({ async = true })
								end)
							end)
						end,
					},
					{
						title = "Go Mod Vendor",
						action = action_go_vendor,
					},
					{
						title = "Generate Test",
						action = action_go_gentest,
					},
					{
						title = "Kubernetes Mod",
						action = action_kubernetes_mod,
					},
				}
			end,
		},
	}
end

return M
