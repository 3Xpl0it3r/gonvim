local util = require("lspconfig/util")

local M = {}

M.gopls = {
	cmd = { "gopls", "serve", "-debug=localhost:8098" },
	filetypes = { "go", "gomod" },
	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			symbolStyle = "Full", -- Full| Dynamic | Package
			------------------------------------------------
			----      Analyses Setting
			------------------------------------------------
			analyses = {
				unusedparams = true,
				unreachable = true,
				fillstruct = true,
			},
			------------------------------------------------
			----      Complete Setting
			------------------------------------------------
			usePlaceholders = true, -- placeholders enables placeholders for function parameters or struct fields in completion responses.
			-- completionBudget = "0ms", -- completionBudget is the soft latency goal for completion requests
			matcher = "Fuzzy", -- matcher sets the algorithm that is used when calculating completion candidates. CaseInsensitive | CaseSensitive | Fuzzy
			completeUnimported = true,
			deepCompletion = true, -- If true, this turns on the ability to return completions from deep inside relevant entities, rather than just the locally accessible ones.
			-- experimentalWatchedFileDelay = "10ms"

			------------------------------------------------
			----      Inlayhint
			------------------------------------------------
			hints = {
				assignVariableTypes = true, -- i/* int*/, j/* int*/ := 0, len(r)-1
				compositeLiteralFields = true, -- {/*in: */"Hello, world", /*want: */"dlrow ,olleH"}
				compositeLiteralTypes = true, -- /*struct{ in string; want string }*/{"Hello, world", "dlrow ,olleH"},
				constantValues = true, -- KindNone   Kind = iota/* = 0*/
				functionTypeParameters = true, -- myFoo/*[int, string]*/(1, "hello")
				parameterNames = true, -- parseInt(/* str: */ "123", /* radix: */ 8)
				rangeVariableTypes = true, -- for k/* int*/, v/* string*/ := range []string{} {
			},
		},
	},
	single_file_support = true,
}

M.golangci_lint_ls = {
	cmd = { "golangci-lint-langserver" },
	init_options = {
		command = { "golangci-lint", "run", "--out-format", "json" },
	},
	filetypes = { "go", "gomod", ".git", ".golangci.yaml" },
	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
	single_file_support = true,
}

return M
