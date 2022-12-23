vim.api.nvim_set_hl(0, "WinBarSignature", { fg = "#dedede", bg = "#363636" })
vim.api.nvim_set_hl(0, "WinBarSigDoc", { fg = "#dedede", bg = "#363636" })
vim.api.nvim_set_hl(0, "WinBarSigActParm", { fg = "#dedede", bg = "#9f3838" })

local treesitter_context = function(width)
	local type_patterns = {
		"class",
		"function",
		"method",
		"interface",
		"type_spec",
	}

	if vim.o.ft == "json" then
		type_patterns = { "object", "pair" }
	end

	local f = require("nvim-treesitter").statusline({
		indicator_size = width,
		type_patterns = type_patterns,
	})
	local context = string.format("%s", f) -- convert to string, it may be a empty ts node

	-- lprint(context)
	if context == "vim.NIL" then
		return " "
	end

	return " " .. context
end

local winbar_status = function()
	local columns = vim.api.nvim_get_option("columns")
	local context = treesitter_context(columns)
	if not pcall(require, "lsp_signature") then
		return context
	end
	local sig = require("lsp_signature").status_line(columns)

	if sig == nil or sig.label == nil or sig.range == nil then
		return context
	end
	local label1 = sig.label
	local label2 = ""
	if sig.range then
		label1 = sig.label:sub(1, sig.range["start"] - 1)
		label2 = sig.label:sub(sig.range["end"] + 1, #sig.label)
	end
	local doc = sig.doc or ""
	if #doc + #sig.label >= columns then
		local trim = math.max(5, columns - #sig.label - #sig.hint - 10)
		doc = doc:sub(1, trim) .. "..."
		-- lprint(doc)
	end

	return "%#WinBarSignature#"
			.. label1
			.. "%*"
			.. "%#WinBarSigActParm#"
			.. sig.hint
			.. "%*"
			.. "%#WinBarSignature#"
			.. label2
			.. "%*"
			.. "%#WinBarSigDoc#"
			.. " "
			.. doc
		or "" .. "%*"
end

local _winbar = vim.api.nvim_create_augroup("_winbar", { clear = true })
vim.api.nvim_create_autocmd(
	{ "CursorMoved", "CursorHold", "BufWinEnter", "BufFilePost", "InsertEnter", "BufWritePost", "TabClosed" },
	{
		group = _winbar,
		callback = function()
			vim.opt.winbar = winbar_status()
		end,
	}
)
