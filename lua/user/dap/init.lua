local M = {}

local _path = "/lua/user/dap/adapter"

local _require_prefix = "user.dap.adapter."

-- 如果需要为其他语言添加dap配置文件,只需要在 lua/user/dap/config/ 目录下创建一个对应语言的文件
-- 例如 需要为java创建一个debug配置, 在 lua/user/dap/config/目录下创建一个 java.lua ，将对应的dap配置添加到java.lua 就可以自动加载了

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. _path, [[v:val =~ '\.lua$']])) do
	local language = file:gsub("%.lua", "")
	M[language] = require(_require_prefix .. language)
end

return M
