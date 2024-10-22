local M = {}


local dapui = require("dapui")

local add_watch_expression = function()
    local opt_cloned = vim.opt.iskeyword
    vim.opt.iskeyword:append(".")
    local variable = vim.fn.expand("<cword>")
    vim.opt.iskeyword = opt_cloned
    -- 判断variable是否已经存在，如果存在则不添加
    local watch_expression_list = dapui.elements.watches.get()
    for _, value in ipairs(watch_expression_list) do
        if value.expression == variable then
            require("utils.notify").notify("Expression [" .. variable .. "] Already Existed", "warn", "DapUi")
            do return end
        end
    end
    dapui.elements.watches.add(variable)
end


local remove_watch_expression = function()
    local watch_expression_list = dapui.elements.watches.get()
    local expression_map_id = {}
    local expression_names = {}
    for index, value in ipairs(watch_expression_list) do
        expression_map_id[value.expression] = index
        table.insert(expression_names, value.expression)
    end
    vim.ui.select(expression_names, { prompt = "Select Watch Expression Del" }, function(expression)
        if expression == nil then
            return
        end
        local id = expression_map_id[expression]
        dapui.elements.watches.remove(id)
    end)
end

local clean_all_watch_expression = function()
    local watch_expression_list = dapui.elements.watches.get()
    for index, _ in ipairs(watch_expression_list) do
        dapui.elements.watches.remove(index)
    end
end

M.key_binds = function(dap, dap_ui)
    -- ---------------------dap keymap configuration --------------------------
    -- add variable to watch windows
    vim.keymap.set("n", "<leader>da", add_watch_expression, { desc = "Dap: Add Watcher" })
    -- delete a varibale from watch windows
    vim.keymap.set("n", "<leader>dd", remove_watch_expression, { desc = "Dap: Del  Watcher" })
    vim.keymap.set("n", "<leader>dD", clean_all_watch_expression, { desc = "Dap: Del All Watcher" })

    -- system manage reference
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: Continue" })

    vim.keymap.set("n", "<leader>dR", dap.restart, { desc = "DAP: Restart process" })
    vim.keymap.set("n", "<leader>de", dap.set_exception_breakpoints, { desc = "DAP: Set exception breakpoints" })
    -- terminalte dap
    vim.keymap.set("n", "<leader>dT", dap.terminate, { desc = "DAP: Dap Terminated" })

    -- breakpioints
    vim.keymap.set("n", "<leader>dB", function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "DAP: Set breakpoint" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle breackpoint" })
    vim.keymap.set("n", "<leader>dl", dap.list_breakpoints, { desc = "DAP: List Breakpoints" })
    vim.keymap.set("n", "<leader>dC", dap.clear_breakpoints, { desc = "DAP: Clear All Breakpoints" })

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
