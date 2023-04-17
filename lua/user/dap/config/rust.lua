local M = {}

M.adapters = function(callback, config) end

M.configurations = {
	{
		type = "rust",
		name = "Debug",
		request = "launch",
		cwd = "${workspaceFolder}",
		args = function()
			return coroutine.create(function(dap_run_co)
				vim.ui.input({
					prompt = "Program arguments: ",
					completion = "file",
					highlight = function()
						return { fg = "blue", bg = "white" }
					end,
				}, function(input)
					coroutine.resume(dap_run_co, vim.fn.split(input, " ", true))
				end)
			end)
		end,
		program = function()
            local cargo_toml = io.open("Cargo.toml", "r")
            for line in cargo_toml.lines() do
                local name = string.match(line, "name=(%w+)")
                if name ~= nil then
                    return "target/debug/"..name
                end
            end
            return "target/debug/".."${workspaceFolder}"
        end,
	},
}

return M
