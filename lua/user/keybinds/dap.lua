local M = {}

M.key_binds = function(dap, dap_ui)
	-- ---------------------dap keymap configuration --------------------------
	vim.keymap.set("n", "<leader>dC", dap.continue, { desc = "DAP: Continue" })
	vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle breackpoint" })
	vim.keymap.set("n", "<leader>dB", function()
		require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, { desc = "DAP: Set breakpoint" })
	vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP: Step over" })
	vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "DAP: Step out" })
	vim.keymap.set("n", "<leader>dn", dap.step_into, { desc = "DAP: Step into" })
	vim.keymap.set("n", "<leader>dN", dap.step_back, { desc = "DAP: Step back" })
	vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "DAP: Toggle REPL" })
	vim.keymap.set("n", "<leader>d.", dap.goto_, { desc = "DAP: Go to" })
	vim.keymap.set("n", "<leader>dh", dap.run_to_cursor, { desc = "DAP: Run to cursor" })
	vim.keymap.set("n", "<leader>de", dap.set_exception_breakpoints, { desc = "DAP: Set exception breakpoints" })
	vim.keymap.set("n", "<leader>dT", dap.terminate, { desc = "DAP: Dap Terminated" })
	-- vim.keymap.set("n", "<leader>dv", require("telescope").extensions.dap.variables, { desc = "DAP-Telescope: Variables" })
	-- vim.keymap.set("n", "<leader>dc", require("telescope").extensions.dap.commands, { desc = "DAP-Telescope: Commands" })
	vim.keymap.set("n", "<leader>dx", require("dapui").eval, { desc = "DAP-UI: Eval" })
	vim.keymap.set("n", "<leader>dX", function()
		dap_ui.eval(vim.fn.input("expression: "))
	end, { desc = "DAP-UI: Eval expression" })
end

return M
