local null_ls = require("null-ls")

local M = {}

M.source = {
	name = "rust formatting",
	method = null_ls.methods.FORMATTING,
	filetypes = { "rust" },
	meta = {
		url = "https://github.com/rust-lang/rustfmt",
		description = "rustfmt is a formatter for Haskell source code.",
	},
	generator = require("null-ls.helpers").formatter_factory({
		command = "rustfmt",
		args = { "--emit=stdout" },
		to_stdin = true,
	}),
}

return M
