local shell = require("utils.shell")
local format_notify = require("utils.notify")

local pickers = require("telescope.pickers") -- used for build a telescope picker
local finders = require("telescope.finders") -- used for build a telescope finder
local previewers = require("telescope.previewers") -- used for build a telescope previewer
local actions = require("telescope.actions") -- used to replace default mapping for user
local action_state = require("telescope.actions.state") -- used to get select entry

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
						action = function ()
						  vim.cmd("MarkdownPreviewToggle")
						end,
					},
				}
			end,
		},
	}
end

return M
