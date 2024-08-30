local util = require("lspconfig/util")
local M = {}
M.clangd = {
	cmd = {
		"clangd",
		"--background-index", -- 后台建立索引，并持久化到disk
		"--clang-tidy", -- 开启clang-tidy
		"--clang-tidy-checks=bugprone-*, clang-analyzer-*, google-*, modernize-*, performance-*, portability-*, readability-*, -bugprone-too-small-loop-variable, -clang-analyzer-cplusplus.NewDelete, -clang-analyzer-cplusplus.NewDeleteLeaks, -modernize-use-nodiscard, -modernize-avoid-c-arrays, -readability-magic-numbers, -bugprone-branch-clone, -bugprone-signed-char-misuse, -bugprone-unhandled-self-assignment, -clang-diagnostic-implicit-int-float-conversion, -modernize-use-auto, -modernize-use-trailing-return-type, -readability-convert-member-functions-to-static, -readability-make-member-function-const, -readability-qualified-auto, -readability-redundant-access-specifiers,",
		"--completion-style=detailed",
		"--cross-file-rename=true",
		"--header-insertion=iwyu",
		"--pch-storage=memory",
		-- 启用这项时，补全函数时，将会给参数提供占位符，键入后按 Tab 可以切换到下一占位符
		"--function-arg-placeholders=false",
		"--log=verbose",
		"--ranking-model=decision_forest",
		-- 输入建议中，已包含头文件的项与还未包含头文件的项会以圆点加以区分
		"--header-insertion-decorators",
		"-j=12",
		"--pretty",
	},
	root_dir = util.root_pattern(
		".git",
		".clangd",
		"compile_flags.txt",
		"compile_commands.json",
		"Makefile",
		"configure.ac"
	),
	filetypes = { "c", "cpp" },
	single_file_support = true,
}

M.ccls = {
	cmd = { "ccls" },
	filetypes = { "c", "cpp" },
	single_file_support = true,
	offset_encoding = "utf-32",
	root_dir = util.root_pattern("compile_commands.json", ".ccls", ".git"),
}

return M
