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
    vim.fn.sign_define("DapStopped", { text = "", texthl = "debugBreakpoint", linehl = "debugPC", numhl = "" })

    -- ---------------------dap keymap configuration --------------------------
    vim.keymap.set("n", "<leader>dC", require("dap").continue, { desc = "DAP: Continue" })
    vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "DAP: Toggle breackpoint" })
    vim.keymap.set("n", "<leader>dB", function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "DAP: Set breakpoint" })
    vim.keymap.set("n", "<leader>do", require("dap").step_over, { desc = "DAP: Step over" })
    vim.keymap.set("n", "<leader>dO", require("dap").step_out, { desc = "DAP: Step out" })
    vim.keymap.set("n", "<leader>dn", require("dap").step_into, { desc = "DAP: Step into" })
    vim.keymap.set("n", "<leader>dN", require("dap").step_back, { desc = "DAP: Step back" })
    vim.keymap.set("n", "<leader>dr", require("dap").repl.toggle, { desc = "DAP: Toggle REPL" })
    vim.keymap.set("n", "<leader>d.", require("dap").goto_, { desc = "DAP: Go to" })
    vim.keymap.set("n", "<leader>dh", require("dap").run_to_cursor, { desc = "DAP: Run to cursor" })
    vim.keymap.set("n", "<leader>de", require("dap").set_exception_breakpoints,
        { desc = "DAP: Set exception breakpoints" })
    -- vim.keymap.set("n", "<leader>dv", require("telescope").extensions.dap.variables, { desc = "DAP-Telescope: Variables" })
    -- vim.keymap.set("n", "<leader>dc", require("telescope").extensions.dap.commands, { desc = "DAP-Telescope: Commands" })
    vim.keymap.set("n", "<leader>dx", require("dapui").eval, { desc = "DAP-UI: Eval" })
    vim.keymap.set("n", "<leader>dX", function()
        dap_ui.eval(vim.fn.input("expression: "))
    end, { desc = "DAP-UI: Eval expression" })

    dap.listeners.after["event_initialized"]["dapui"] = function()
        dap_ui.open()
    end
    dap.listeners.after["event_terminated"]["dapui"] = function()
        dap_ui.close()
        vim.cmd("bd! \\[dap-repl]")
    end

    dap.listeners.before['event_progressStart']['progress-notifications']  = require("utils.notify").event_progressStart
    dap.listeners.before['event_progressUpdate']['progress-notifications'] = require("utils.notify").event_progressUpdate
    dap.listeners.before['event_progressEnd']['progress-notifications']    = require("utils.notify").event_progressEnd


    -- config go debuger
    require("conf.dap.go").config(dap)
    require("conf.dap.rust").config(dap)
end

function M.setup()
    local dap = require("dap")
    local dap_ui = require("dapui")
    config_dap(dap, dap_ui)
end

return M
