local M = {}

function M.new_kanagawa_options()
	return {
		undercurl = true, -- enable undercurls
		commentStyle = { italic = true },
		functionStyle = {},
		keywordStyle = { italic = true },
		statementStyle = { bold = true },
		typeStyle = {},
		variablebuiltinStyle = { italic = true },
		specialReturn = true, -- special highlight for the return keyword
		specialException = true, -- special highlight for exception handling keywords
		transparent = false, -- do not set background color
		dimInactive = false, -- dim inactive window `:h hl-NormalNC`
		globalStatus = false, -- adjust window separators highlight for laststatus=3
		terminalColors = true, -- define vim.g.terminal_color_{0,17}
		colors = {},
		-- overrides = {},
	}
end

function M.new_onenord_options()
	return {
		theme = "dark", -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
		borders = true, -- Split window borders
		fade_nc = false, -- Fade non-current windows, making them more distinguishable
		-- Style that is applied to various groups: see `highlight-args` for options
		styles = {
			comments = "NONE",
			strings = "NONE",
			keywords = "NONE",
			functions = "NONE",
			variables = "NONE",
			diagnostics = "underline",
		},
		disable = {
			background = false, -- Disable setting the background color
			cursorline = false, -- Disable the cursorline
			eob_lines = true, -- Hide the end-of-buffer lines
		},
		-- Inverse highlight for different groups
		inverse = {
			match_paren = false,
		},
		custom_highlights = {}, -- Overwrite default highlight groups
		custom_colors = {}, -- Overwrite default colors
	}
end

function M.new_nightfox_options()
	return {
		options = {
			-- Compiled file's destination location
			compile_path = vim.fn.stdpath("cache") .. "/nightfox",
			compile_file_suffix = "_compiled", -- Compiled file suffix
			transparent = false, -- Disable setting background
			terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
			dim_inactive = false, -- Non focused panes set to alternative background
			styles = { -- Style to be applied to different syntax groups
				comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
				conditionals = "NONE",
				constants = "NONE",
				functions = "NONE",
				keywords = "NONE",
				numbers = "NONE",
				operators = "NONE",
				strings = "NONE",
				types = "NONE",
				variables = "NONE",
			},
			inverse = { -- Inverse highlight for different types
				match_paren = false,
				visual = false,
				search = false,
			},
			modules = { -- List of various plugins and additional options
				-- ...
			},
		},
		palettes = {},
		specs = {},
		groups = {},
	}
end

function M.new_onedarkpro_options()
	return {
		dark_theme = "onedark", -- The default dark theme
		light_theme = "onelight", -- The default light theme
		colors = {}, -- Override default colors by specifying colors for 'onelight' or 'onedark' themes
		plugins = { -- Override which plugin highlight groups are loaded
			-- See the Supported Plugins section for a list of available plugins
		},
		styles = { -- Choose from "bold,italic,underline"
			strings = "NONE", -- Style that is applied to strings.
			comments = "NONE", -- Style that is applied to comments
			keywords = "NONE", -- Style that is applied to keywords
			functions = "NONE", -- Style that is applied to functions
			variables = "NONE", -- Style that is applied to variables
			virtual_text = "NONE", -- Style that is applied to virtual text
		},
		options = {
			bold = false, -- Use the colorscheme's opinionated bold styles?
			italic = false, -- Use the colorscheme's opinionated italic styles?
			underline = false, -- Use the colorscheme's opinionated underline styles?
			undercurl = false, -- Use the colorscheme's opinionated undercurl styles?
			cursorline = false, -- Use cursorline highlighting?
			transparency = false, -- Use a transparent background?
			terminal_colors = false, -- Use the colorscheme's colors for Neovim's :terminal?
			window_unfocused_color = false, -- When the window is out of focus, change the normal background?
		},
	}
end

function M.new_tokyonight_options()
	return {
		style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
		light_style = "day", -- The theme is used when the background is set to light
		transparent = false, -- Enable this to disable setting the background color
		terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
		styles = {
			-- Style to be applied to different syntax groups
			-- Value is any valid attr-list value for `:help nvim_set_hl`
			comments = { italic = true },
			keywords = { italic = true },
			functions = {},
			variables = {},
			-- Background styles. Can be "dark", "transparent" or "normal"
			sidebars = "dark", -- style for sidebars, see below
			floats = "dark", -- style for floating windows
		},
		sidebars = { "qf", "help", "terminal", "packer", "toggleterm" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
		day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
		hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
		dim_inactive = false, -- dims inactive windows
		lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

		--- You can override specific color groups to use other groups or a hex color
		--- function will be called with a ColorScheme table
		---@param colors ColorScheme
		on_colors = function(colors) end,

		--- You can override specific highlights to use other groups or a hex color
		--- function will be called with a Highlights and ColorScheme table
		---@param highlights Highlights
		---@param colors ColorScheme
		on_highlights = function(highlights, colors) end,
	}
end

return M
