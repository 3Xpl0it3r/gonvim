local util = require("lspconfig/util")

local M = {}

M.marksman = {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "markdown.mdx" },
	root_dir = util.root_pattern(".git", ".marksman.toml"),
	single_file_support = true,
}


return M
