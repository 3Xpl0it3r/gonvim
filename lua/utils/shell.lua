local M= {}

function M.execute(cus_cmd)
	local wraper_cmd = "time "
	local shell = os.getenv("SHELL")
	if string.find(tostring(shell), "zsh") then
		wraper_cmd = cus_cmd .. "&& read -s -k $'?Press any key to continue.\n'"
	else
		wraper_cmd = cus_cmd .. "&& read -rsn1 -p'Press any key to continue';echo"
	end
	local __Terminal = require("toggleterm.terminal").Terminal
	local cmd_termal = __Terminal:new({
		cmd = wraper_cmd,
		direction = "float",
		float_opts = {
			border = "single",
			close_on_exit = true,
			clear_env = false,
		},
	})
	cmd_termal:toggle()
end


return M
