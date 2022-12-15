local util = require("lspconfig/util")

local pyright = {
	cmd = { "pyright-langserver", "--stdio" },
	filetype = { "python", "python3" },
    root_dir = util.root_pattern(vim.fn.getcwd()),
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

local pylsp = {
	cmd = { "pylsp" },
	filetype = { "python", "python3" },
    root_dir = util.root_pattern(vim.fn.getcwd()),
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					ignore = { "W391" },
					maxLineLength = 100,
				},
			},
		},
	},
	single_file_support = true,
}

local jedi_language_server = {
	cmd = { "jedi-language-server" },
	filetype = { "python", "python3" },
    root_dir = util.root_pattern(vim.fn.getcwd()),
	single_file_support = true,
}

return {
	pyright = pyright,
	pylsp = pylsp,
	jedi_language_server = jedi_language_server,
}
