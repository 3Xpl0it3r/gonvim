util = require("lspconfig/util")

local M = {}

M.java_language_server = {
	cmd = { "lua-language-server" },
	filetypes = { "java" },
	root_dir = util.root_pattern(".git", vim.fn.getcwd()),
	settings = {},
	single_file_support = true,
}

M.jdtls = {
	cmd = { "jdtls", "-configuration", "/home/runner/.cache/jdtls/config", "-data", "$HOME/.cache/jdtls/workspace" },
	filetypes = { "java" },
	handlers = {
		-- todo
	},
	init_options = {
		jvm_args = {},
		workspace = "$HOME/.cache/jdtls/workspace",
	},
	root_dir = util.root_pattern(
		"build.xml",
		"pom.xml",
		"settings.gradle",
		"settings.gradle.kts",
		"build.gradle",
		"build.gradle.kts",
		vim.fn.getcwd()
	),
	single_file_support = true,
}

return M
