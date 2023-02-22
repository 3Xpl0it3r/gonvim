local M = {}

local util = require("lspconfig/util")

M.rust_analyzer = {
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

M.rls = {
	cmd = { "rls" },
	filetype = { "rust" },
	root_dir = util.root_pattern("Cargo.toml", "rust-project.json"),
	settings = {
		rust = {
			unstable_features = true,
			build_on_save = false,
			all_features = true,
		},
	},
}

return M
