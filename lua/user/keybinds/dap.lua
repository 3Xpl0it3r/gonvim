local M = {}

M.key_binds = function(dap, dap_ui)
	-- ---------------------dap keymap configuration --------------------------
    
    -- system manage reference
	vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: Continue" })
	vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle breackpoint" })
	vim.keymap.set("n", "<leader>dB", function()
		require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, { desc = "DAP: Set breakpoint" })


	vim.keymap.set("n", "<leader>dR", dap.restart, { desc = "DAP: Restart process" })
	vim.keymap.set("n", "<leader>de", dap.set_exception_breakpoints, { desc = "DAP: Set exception breakpoints" })
    -- terminalte dap 
	vim.keymap.set("n", "<leader>dT", dap.terminate, { desc = "DAP: Dap Terminated" })


    -- debug reference  
    -- running programming
	vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "DAP: Step over to next cursor line" })
	vim.keymap.set("n", "<leader>ds", dap.step_into, { desc = "DAP: Single step through program" })
	vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "DAP: Step out of the current function" })

	vim.keymap.set("n", "<leader>dj", dap.run_to_cursor, { desc = "DAP: Run to cursor" }) -- for jump

    -- console reference
	vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "DAP: Toggle REPL" })

	vim.keymap.set("n", "<leader>dx", require("dapui").eval, { desc = "DAP-UI: Eval" })
	vim.keymap.set("n", "<leader>dX", function()
		dap_ui.eval(vim.fn.input("expression: "))
	end, { desc = "DAP-UI: Eval expression" })
end

return M
