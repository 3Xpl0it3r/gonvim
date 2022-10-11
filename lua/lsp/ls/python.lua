lspconfig = require("lspconfig")
util = require("lspconfig/util")

return {
	cmd = { "pyright-langserver", "--stdio" },
	filetype = "python",
	root_dir = util.root_pattern(".git", "pymod"),
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
			},
		},
	},
	single_file_support = true,
}
