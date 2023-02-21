
local M = {}

local gosnippets = {
	common = require("user/snippets/rust/common"),
}

for _, snips_block in pairs(gosnippets) do
	for _, single_snip in ipairs(snips_block) do
		table.insert(M, single_snip)
	end
end

return M

