local status_ok, _ = pcall(require, "lsp_signature")
if not status_ok then
	require("utils.notify").notify("Plugin lsp_signature is not existed", "error", "Plugin")
	return
end

local M = {}

local function config_lsp_signature(config)
	config.setup({
		bind = true, -- this is mandatory, otherwise border config won't get register
		wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
		doc_lines = 10,
		max_height = 12,
		max_width = 80,
		floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
		floating_window_above_cur_line = true,
		floating_window_off_x = 1,
		floating_window_off_y = 0,
		close_timeout = 4000,
		fix_pos = true, -- set to true, the floating windows will not auto-close until finsih all parameters
		hint_enable = true,
		hint_prefix = "🐼",
		hi_parameter = "LspSignatureActiveParameter",
		handler_opts = {
			border = "rounded",
		},
		always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
		auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
		extra_trigger_chars = {},
		zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom
		padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
		transparency = nil, -- disabled by default, allow floating win transparent value 1~100
		shadow_blend = 36, -- if you using shadow as border use this set the opacity
		shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
		timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
		toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'

		select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
		move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
	})
end

function M.setup()
	config_lsp_signature(require("lsp_signature"))
end

return M
