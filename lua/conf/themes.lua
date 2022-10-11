local status_ok, kanagawa_config = pcall(require, "kanagawa")
if status_ok then
    local default_colors = require("kanagawa.colors").setup()
    kanagawa_config.setup({
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
        overrides = {},
    })
    -- setup must be called before loading
end

local status_ok, gruvbox_config = pcall(require, "gruvbox")
if status_ok then
    gruvbox_config.setup({
        undercurl = true,
        underline = true,
        bold = true,
        italic = true,
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        overrides = {},
    })
    -- setup must be called before loading
end

local status_ok, onenord_config = pcall(require, "onenord")
if status_ok then
    onenord_config.setup({
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
    })
    -- setup must be called before loading
end

local status_ok, nightfox_config = pcall(require, "nightfox")
if status_ok then
    nightfox_config.setup({
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
    })
end
-- Nordfox

local status_ok, onedarkpro_config = pcall(require, "onedarkpro")
if status_ok then
    onedarkpro_config.setup({
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
    })
end

