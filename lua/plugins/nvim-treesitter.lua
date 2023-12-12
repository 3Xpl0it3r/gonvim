local status_ok, _ = pcall(require, "nvim-treesitter")
if not status_ok then
	require("utils.notify").notify("Plugin nvim-treesitter is not existed", "error", "Plugin")
	return
end

local M = {}

local function config_nvim_treesitter(config)
	config.setup({
		ensure_installed = {
			"c",
			"cpp",
			"python",
			"go",
			"rust",
			"lua",
			"bash",
			"json",
			"proto",
			"vim",
		},
		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,
		auto_install = true,
		-- auto tag with nvim-ts-autotag
		autotag = { enable = true },
		autopairs = { enable = true },
		highlight = {
			enable = true,
			disable = { "" },
			additional_vim_regex_higlighting = true,
		},
		indent = { enable = false, disable = { "" } },
		--[[ context_commentstring = {
			enable = true,
			single_line_comment_string = "auto",
			multi_line_comment_strings = "auto",
			config = {
				go = { __default = "// %s", __multiline = "/* %s */" },
				rust = { __default = "// %s", __multiline = "/* %s */" },
				c = { __default = "// %s", __multiline = "/* %s */" },
				python = { __default = "# %s", __multiline = "# %s" },
			},
		}, ]]
	})

	-- vim.o.foldmethod = "expr"
	-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
end

function M.setup()
	config_nvim_treesitter(require("nvim-treesitter.configs"))
end

return M
