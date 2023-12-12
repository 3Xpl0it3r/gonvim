local status_ok, _ = pcall(require, "ts_context_commentstring")
if not status_ok then
	require("utils.notify").notify("Plugin ts_context_commentstring is not existed", "error", "Plugin")
	return
end

local M = {}

local function config_ts_context_comment(config)
	config.setup({
		languages = {
			javascript = {
				__default = "// %s",
				jsx_element = "{/* %s */}",
				jsx_fragment = "{/* %s */}",
				jsx_attribute = "// %s",
				comment = "// %s",
			},
		},
	})
end

function M.setup()
	config_ts_context_comment(require("ts_context_commentstring"))
end

return M
