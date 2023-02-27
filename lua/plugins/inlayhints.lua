local status_ok, _ = pcall(require, "lsp-inlayhints")
if not status_ok then
	require("utils.notify").notify("Plugin lspconfig is not existed", "error", "Plugin")
	return
end

local M = {}

local function config_inlayhint(inlayhints)
	local config = {
		inlay_hints = {
			parameter_hints = {
				show = true,
				prefix = "<- ",
				separator = ", ",
				remove_colon_start = false,
				remove_colon_end = true,
			},
			type_hints = {
				-- type and other hints
				show = true,
				prefix = "",
				separator = ", ",
				remove_colon_start = false,
				remove_colon_end = false,
			},
			only_current_line = false,
			-- separator between types and parameter hints. Note that type hints are
			-- shown before parameter
			labels_separator = "  ",
			-- whether to align to the length of the longest line in the file
			max_len_align = false,
			-- padding from the left if max_len_align is true
			max_len_align_padding = 1,
			-- highlight group
			highlight = "LspInlayHint",
			-- virt_text priority
			priority = 0,
		},
		enabled_at_startup = true,
		debug_mode = false,
	}

	inlayhints.setup(config)
end

function M.setup()
	config_inlayhint(require("lsp-inlayhints"))
end

return M
