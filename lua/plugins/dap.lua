local status_ok, _ = pcall(require, "dap")
if not status_ok then
	require("utils.notify").notify("Plugin dap is not existed", "error", "Plugin")
	return
end

local M = {}

local function config_dap(dap, dap_ui)
	-- ---------------------dap icons  configuration ----------------------------

	vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "debugBreakpoint", linehl = "", numhl = "" })
	vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
	vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
	vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "debugBreakpoint", linehl = "", numhl = "" })
	vim.fn.sign_define("DapStopped", { text = "󰋇 ", texthl = "debugBreakpoint", linehl = "debugPC", numhl = "" })

	dap.listeners.after["event_initialized"]["dapui"] = function()
		dap_ui.open()
	end
	dap.listeners.after["event_terminated"]["dapui"] = function()
		dap_ui.close()
	end
	dap.listeners.before["event_exited"]["dapui_config"] = function()
		dap_ui.close()
	end

	dap.listeners.before["event_progressStart"]["progress-notifications"] = require("utils.notify").event_progressStart
	dap.listeners.before["event_progressUpdate"]["progress-notifications"] =
		require("utils.notify").event_progressUpdate
	dap.listeners.before["event_progressEnd"]["progress-notifications"] = require("utils.notify").event_progressEnd

	-- dap.adapters["xxx"] = ""
	for language, dapconfig in pairs(require("user.dap")) do
		dap.adapters[language] = dapconfig.adapters
		dap.configurations[language] = dapconfig.configurations
	end
end

function M.setup()
	local dap = require("dap")
	local dap_ui = require("dapui")
	config_dap(dap, dap_ui)
	require("user.keybinds.dap").key_binds(dap, dap_ui)
end

return M
