local M = {}

local icons = require("ui.icons")

vim.api.nvim_create_autocmd("CursorHold", {
	buffer = bufnr,
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			prefix = " ",
			scope = "cursor",
		}
		vim.diagnostic.open_float(nil, opts)
	end,
})
local function goto_definition(split_cmd)
	local util = vim.lsp.util
	local log = require("vim.lsp.log")
	local api = vim.api

	-- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
	local handler = function(_, result, ctx)
		if result == nil or vim.tbl_isempty(result) then
			local _ = log.info() and log.info(ctx.method, "No location found")
			return nil
		end

		if split_cmd then
			vim.cmd(split_cmd)
		end

		if vim.tbl_islist(result) then
			util.jump_to_location(result[1])

			if #result > 1 then
				-- util.set_qflist(util.locations_to_items(result))
				-- vim.fn.setqflist(util.locations_to_items(result, "utf-8"))
				vim.fn.setloclist(0, util.locations_to_items(result, "utf-8"), " ")
				api.nvim_command("copen")
				api.nvim_command("wincmd p")
                vim.api.nvim_command('cclose') -- for disable qflist
			end
		else
			util.jump_to_location(result)
		end
	end

	return handler
end

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
		{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warn },
		{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
		{ name = "DiagnosticSignInfo", text = icons.diagnostics.Info },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = {
			prefix = icons.misc.fake, -- Could be '●', '▎', 'x', '■' '◉ '
		},
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}
	vim.diagnostic.config(config)
	vim.lsp.handlers["textDocument/definition"] = goto_definition("vsplit")
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

	-- LSP integration
	vim.lsp.handlers["$/progress"] = require("utils.notify").lsp_status_update
	vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
		local severity = { "error", "warn", "info", "info" } -- map both hint and info to info?
		vim.notify(method.message, severity[params.type])
	end
end

local function lsp_keymaps(bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>", { noremap = true })
	vim.keymap.set("n", "gr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", { noremap = true })
	vim.keymap.set("n", "gf", vim.lsp.buf.format, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)

	-- vim.keymap.set("n", "<space>rn", "<cmd>lua CusLspActionRename.rename()<CR>", bufopts)
	vim.keymap.set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		return
	end
	illuminate.on_attach(client)
	-- end
end

M.on_attach = function()
	return function(client, bufnr)
		-- disable formatting for LSP clients as this is handled by null-ls
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
		local lsp_signature_avail, lsp_signature = pcall(require, "lsp_signature")
		if lsp_signature_avail then
			lsp_signature.on_attach()
		end
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
		lsp_keymaps(bufnr)
		lsp_highlight_document(client)
	end
end

M.capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.codeAction = {
		dynamicRegistration = true,
		codeActionLiteralSupport = {
			codeActionKind = {
				valueSet = (function()
					local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
					table.sort(res)
					return res
				end)(),
			},
		},
	}
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if not status_ok then
		return
	end
	capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	return capabilities
end

return M
