local M = {}


M.adapters = {
	type = "executable",
	command = os.getenv("LLVM_HOME") and os.getenv("LLVM_HOME") .. "/bin/lldb-vscode" or "lldb-vscode",
	name = "rust",
}

M.configurations = {
	{
		name = "Launch file",
		type = "rust",
		request = "launch",
		program = function()
			for line in io.lines("Cargo.toml") do
				local name = string.match(line, 'name = "(%w+)"')
				if name ~= nil then
					return "target/debug/" .. name
				end
			end
			return "target/debug/" .. "${workspaceFolder}"
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		terminal = "integrated",
	},
}

return M
