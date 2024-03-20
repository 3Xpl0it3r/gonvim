local M = {}

local json_util = require("utils.json")

local godbolt_db = ".godbolt"

-- lang: str  the compilers that match the language
-- return {desc2=name, desc=name1}
function M.compilers(lang)
	-- juedget cache is existed
	local godbolt_cache = vim.lsp.buf.list_workspace_folders()[1] .. "/" .. godbolt_db
	if vim.loop.fs_stat(godbolt_cache) then
		local special_compiles = json_util.load(godbolt_db)[lang]
		if special_compiles ~= nil then
			return special_compiles
		end
	end

	local compilers = {}
	compilers[lang] = {}
	-- query godbolts api
	local cmd = "curl -s -X GET https://godbolt.org/api/compilers/" .. lang .. " |grep -v Name"
	local response = vim.fn.system(cmd)
	for item in response:gmatch("[^\r\n]+") do
		local tokens = vim.split(item, "|")
		local name = string.gsub(tokens[1], "%s+", "")
		local desc_formatter = string.gsub(tokens[2], "^%s+", "")
		local desc_token = vim.split(desc_formatter, " ")
		if #desc_token == 3 then
			desc_formatter = string.format("%-10s\t%-8s\t%8s\n", desc_token[2], desc_token[3], desc_token[1])
		end
		compilers[lang][desc_formatter] = name
	end

	-- cache the result
	json_util.dump(godbolt_db, compilers)
	return compilers[lang]
end

function M.compile_term(compiler, source_code, opts)
	local cmd = "curl -s 'https://godbolt.org/api/compiler/" .. compiler .. "/compile"
	if opts ~= nil and opts ~= "" then
		cmd = cmd .. "?options=" .. opts .. "'"
	else
		cmd = cmd .. "'"
	end
	cmd = cmd .. " --data-binary '" .. source_code .. "' "

	local shell = os.getenv("SHELL")
	if string.find(tostring(shell), "zsh") then
		cmd = cmd .. "&& read -s -k $'?Press any key to continue.\n'"
	else
		cmd = cmd .. "&& read -rsn1 -p'Press any key to continue';echo"
	end

	local Terminal = require("toggleterm.terminal").Terminal
	local compile_term = Terminal:new({ cmd = cmd, hidden = false, direction = "vertical", size = vim.o.columns * 0.4 })
	compile_term:toggle()
end

function M.compile(compiler, source_code, opts)
	local cmd = "curl -s 'https://godbolt.org/api/compiler/" .. compiler .. "/compile"
	if opts ~= nil or opts ~= "" then
		cmd = cmd .. "?options=" .. opts .. "'"
	end
	cmd = cmd .. " --data-binary '" .. source_code .. "'"

	return vim.fn.system(cmd)
end

return M
