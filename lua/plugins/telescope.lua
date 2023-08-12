local status_ok, _ = pcall(require, "telescope")
if not status_ok then
	require("utils.notify").notify("Plugin telescope is not existed", "error", "Plugin")
	return
end

local M = {}

local function config_telescope(telescope)
	local previewers = require("telescope.previewers")
	local Job = require("plenary.job")
	local new_maker = function(filepath, bufnr, opts)
		filepath = vim.fn.expand(filepath)
		Job:new({
			command = "file",
			args = { "--mime-type", "-b", filepath },
			on_exit = function(j)
				local mime_type = vim.split(j:result()[1], "/")[1]
				if mime_type == "text" then
					previewers.buffer_previewer_maker(filepath, bufnr, opts)
				else
					-- maybe we want to write something to the buffer here
					vim.schedule(function()
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
					end)
				end
			end,
		}):sync()
	end

	telescope.setup({
		defaults = {
			-- Default configuration for telescope goes here:
			-- config_key = value,
			buffer_previewer_maker = new_maker,
			prompt_prefix = " ",
			wrap_results = true,
			selection_caret = " ",
			entry_prefix = "  ",
			initial_mode = "insert",
			selection_strategy = "reset",
			sorting_strategy = "ascending",
			file_ignore_patterns = { "^vendor/", "^target/" },
			-- layout_strategy = "vertical",
			layout_strategy = "horizontal",
			layout_config = {
				-- prompt_position = "bottom",
				height = 0.90,
				width = 0.85,
				preview_cutoff = 1,
			},
			borderchars = require("ui.icons").borderchars,
			color_devicons = true,
			use_less = true,
			set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
			mappings = require("user.keybinds.telescope").defaults_key_mapping,
		},
		pickers = {
			find_files = { -- basic filename to fine files
				layout_strategy = "horizontal",
				layout_config = {
					prompt_position = "top",
					preview_width = 0.5,
				},
				mappings = require("user.keybinds.telescope").find_files_key_mapping,
				find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "-L" },
			},
			live_grep = { -- basic context to find files
				--[[ layout_strategy = "vertical",
				layout_config = {
					prompt_position = "top",
					height = 0.90,
					width = 0.80,
				}, ]]
				layout_strategy = "horizontal",
                layout_config = {
                    prompt_position = "bottom",
                    height = 0.90,
                    width = 0.90,
                },
				mappings = require("user.keybinds.telescope").live_grep_key_mapping,
			},

		},
		extensions = {
			fzf = {
				fuzzy = true, -- false wil only do exact matching
				override_generic_sorter = true, -- override then generic sorter
				override_file_sorter = true, -- override then file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
			aerial = {
				-- Display symbols as <root>.<parent>.<symbol>
				show_nesting = {},
			},
		},
	})
end

local function third_party_integrations(telescope)
	local aerial_present, _ = pcall(require, "aerial")
	if aerial_present then
		telescope.load_extension("aerial")
	end
end

local function config_highlights()
	local highlights = {
		-- Sets the highlight for selected items within the picker.
		-- preview
		TelescopePreviewTitle = { fg = "#FF7433" },
		TelescopePromptTitle = { fg = "#FF7433" },
		TelescopeResultsTitle = { fg = "#FF7433" },

		TelescopeBorder = { fg = "#4FC3F7" },
		TelescopePromptBorder = { fg = "#B77BFA" },
		TelescopePreviewBorder = { fg = "#9CCC65" },
		TelescopeResultsBorder = { fg = "#4FC3F7" },
	}
	for k, v in pairs(highlights) do
		vim.api.nvim_set_hl(0, k, v)
	end
end

function M.setup()
	local telescope = require("telescope")
	third_party_integrations(telescope)
	config_telescope(telescope)
	config_highlights()
end

return M
