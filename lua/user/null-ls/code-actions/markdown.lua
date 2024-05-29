local M = {}

function M.sources()
	return {
		method = require("null-ls").methods.CODE_ACTION,
		filetypes = { "markdown" },
		generator = {
			fn = function(_)
				return {
					{
						title = "Preview",
						action = function()
							vim.cmd("MarkdownPreviewToggle")
						end,
					},
				}
			end,
		},
	}
end

return M
