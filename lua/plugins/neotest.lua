local status_ok, _ = pcall(require, "neotest")
if not status_ok then
	require("utils.notify").notify("neotest not found!", "error", "Plugin")
	return
end

local M = {}

local function register(neotest)
	neotest.setup({
		adapters = {
			-- for rust
			require("neotest-rust")({
				args = { "--no-capture" },
				dap_adapter = "rust",
			}),
			-- for golang
			require("neotest-go")({
				experimental = { test_table = true },
				args = { "--count=1", "--timeout=60s" },
				dap_adapter = "go",
			}),
		},
	})
end

M.setup = function()
	register(require("neotest"))
end

return M
