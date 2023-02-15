local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
	require("utils.notify").notify("Plugin lspconfig is not existed", "error", "Plugin")
	return
end

local M = {}

local function config_lspconfig(handler)
	local opts = {
		on_attach = handler.on_attach(),
		capabilities = handler.capabilities(),
	}

	-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
	local server_configs = {
		cpp = {
			server = "clangd",
			configs = require("conf/lsp/ls/c_cpp"),
		},
		python = {
			server = "jedi_language_server",
			-- server = "pyright",
			configs = require("conf/lsp/ls/python"),
		},
		golang = {
			server = "gopls",
			configs = require("conf/lsp/ls/golang"),
		},
		rust = {
			server = "rust_analyzer",
			configs = require("conf/lsp/ls/rust"),
		},
		lua = {
			server = "lua_ls",
			configs = require("conf/lsp/ls/lua"),
		},
		csharp = {
			server = "omnisharp",
			configs = require("conf/lsp/ls/csharp"),
		},
		java = {
			server = "jdtls",
			configs = require("conf/lsp/ls/java"),
		},
	}

	for _, sig_item in pairs(server_configs) do
		local opts_clone = opts
		if sig_item.server == "clangd" then
			opts_clone.capabilities.offsetEncoding = { "utf-16" }
		end
		opts_clone = vim.tbl_deep_extend("force", sig_item["configs"][sig_item["server"]], opts)
		lspconfig[sig_item["server"]].setup(opts_clone)
	end
end

function M.setup()
	local handler = require("conf/lsp/handler")
	handler.setup()
	config_lspconfig(handler)
end

return M
