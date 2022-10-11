local util = require("lspconfig/util")

return {
	cmd = { "rust-analyzer" },
	filetype = { "rust" },
	root_dir = util.root_pattern("Cargo.toml", "rust-project.json"),
	settings = {
		["rust-analyzer"] = {
			assist = {
				importGranularity = "module",
				importPrefix = "self",
			},
			cargo = {
				loadOutDirsFromCheck = true,
                autoreload = true,
                allFeatures = true,
			},
			procMacro = {
				enable = true,
			},
		},
	},
}
