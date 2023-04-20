local M = {}

local get_git_root_dir = function(start_dir, be_finded_dir)
	-- return vim.fn.fnamemodify(vim.fn.finddir(be_finded, "..;"), ":h")

	-- 使用vim.loop.fs_stat检查目录是否存在
	local stat = vim.loop.fs_stat(start_dir)
	-- 如果不存在，返回nil
	if not stat then
		return nil
	end
	-- 如果存在，拼接.git目录的路径
	local git_dir = start_dir .. be_finded_dir
	-- 使用vim.loop.fs_stat检查.git目录是否存在
	local git_stat = vim.loop.fs_stat(git_dir)
	-- 如果存在，返回当前目录
	if git_stat then
		return start_dir
	end
	-- 如果不存在，获取上一级目录的路径
	local parent_dir = vim.fn.fnamemodify(start_dir, ":h")
	-- 如果上一级目录和当前目录相同，说明已经到达根目录，返回nil
	if parent_dir == start_dir then
		return nil
	end
	-- 否则，递归调用函数，传入上一级目录作为参数
	return M.get_git_root_dir(parent_dir, be_finded_dir)
end

M.adapters = {
	type = "server",
	port = "${port}",
	executable = {
		-- CHANGE THIS to your path!
		command = "/Users/l0calh0st/.vscode/extensions/vadimcn.vscode-lldb-1.9.0/adapter/codelldb",
		args = { "--port", "${port}" },

		-- On windows you may have to uncomment this:
		-- detached = false,
	},
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
		-- showDisassembly = "never",
	},
}

return M
