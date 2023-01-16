local M = {}

local gosnippets = {
	common = require("conf/snippets/go/common"),
	alg_array = require("conf/snippets/go/algorithm/sort"),
}

for _, snips_block in pairs(gosnippets) do
	for _, single_snip in ipairs(snips_block) do
		table.insert(M, single_snip)
	end
end

return M
