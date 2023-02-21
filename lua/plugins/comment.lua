local status_ok, _ = pcall(require, "Comment")
if not status_ok then
    require("utils.notify").notify("Plugin Comment is not existed", "error", "Plugin")
	return
end

-- this is for ts_context_commentstring
require("ts_context_commentstring.internal").update_commentstring({
	key = "__multiline",
})

require("ts_context_commentstring.internal").calculate_commentstring({
	location = require("ts_context_commentstring.utils").get_cursor_location(),
})

-- end ts_context_commentstring

local M = {}

local function config_keymap()
	vim.keymap.set("n", "?", '<CMD>lua require("Comment.api").toggle_current_linewise()<CR>')
	vim.keymap.set("x", "?", '<CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>')

	vim.keymap.set("x", "_", '<CMD>lua require("Comment.api").toggle_blockwise_op(vim.fn.visualmode())<CR>')
end

local function config_comment()
	require("Comment").setup({
		---Add a space b/w comment and the line
		---@type boolean|fun():boolean
		padding = true,

		---Whether the cursor should stay at its position
		---NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
		---@type boolean
		sticky = true,

		---Lines to be ignored while comment/uncomment.
		---Could be a regex string or a function that returns a regex string.
		---Example: Use '^$' to ignore empty lines
		---@type string|fun():string
		ignore = nil,

		---LHS of toggle mappings in NORMAL + VISUAL mode
		---@type table
		toggler = {
			---Line-comment toggle keymap
			---Block-comment toggle keymap
		},

		---LHS of operator-pending mappings in NORMAL + VISUAL mode
		---@type table
		opleader = {
			---Line-comment keymap
			---Block-comment keymap
		},

		---LHS of extra mappings
		---@type table
		extra = {},

		---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
		---NOTE: If `mappings = false` then the plugin won't create any mappings
		---@type boolean|table
		mappings = {
			---Operator-pending mapping
			---Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
			---NOTE: These mappings can be changed individually by `opleader` and `toggler` config
			basic = false,
			---Extra mapping
			---Includes `gco`, `gcO`, `gcA`
			extra = false,
			---Extended mapping
			---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
			extended = false,
		},

		---Pre-hook, called before commenting the line
		---@type fun(ctx: CommentCtx):string
		pre_hook = nil,

		---Post-hook, called after commenting is done
		---@type fun(ctx: CommentCtx)
		post_hook = nil,
	})
end

local function config_filetype_language()
	local ft = require("Comment.ft")
	ft.set("yaml", "#%s")
	ft({ "go", "rust", "cpp" }, { "//%s", "/*%s*/" })
	ft({ "shell", "python" }, { "# %s" })
end

function M.setup()
	config_keymap()
	config_comment()
	config_filetype_language()
end

return M
