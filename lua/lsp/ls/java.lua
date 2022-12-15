util = require("lspconfig/util")

local java_language_server = {
	cmd = { "lua-language-server" },
	filetypes = { "java" },
	root_dir = util.root_pattern(".git"),
	settings = {},
	single_file_support = true,
}

local jdtls = {
	cmd = { "jdtls", "-configuration", "/home/runner/.cache/jdtls/config", "-data", "$HOME/.cache/jdtls/workspace" },
	filetypes = { "java" },
	handlers = {
		-- todo
	},
	init_options = {
		jvm_args = {},
		workspace = "$HOME/.cache/jdtls/workspace",
	},
	root_dir = {
		-- Single-module projects
		{
			"build.xml", -- Ant
			"pom.xml", -- Maven
			"settings.gradle", -- Gradle
			"settings.gradle.kts", -- Gradle
		},
		-- Multi-module projects
		{ "build.gradle", "build.gradle.kts" },
	},
	single_file_support = true,
}

return {
	java_language_server = java_language_server,
	jdtls = jdtls,
}
