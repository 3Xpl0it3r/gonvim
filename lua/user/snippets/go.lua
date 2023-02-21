local M = {}

local gosnippets = {
	common = require("user/snippets/go/common"),
    wrap = require("user/snippets/go/wrap"),
	alg_array = require("user/snippets/go/algorithm/sort"),
}

for _, snips_block in pairs(gosnippets) do
	for _, single_snip in ipairs(snips_block) do
		table.insert(M, single_snip)
	end
end

return M
