local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)
vim.o.termguicolors = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local plugins = {
    ------------------------------------------------
    ----      ColorsTheme , UI               -------
    ------------------------------------------------
    {
        -- 主题优先加载, 防止后面覆盖自定义的配色
        "folke/tokyonight.nvim",
        --[[ "rebelot/kanagawa.nvim",
        "catppuccin/nvim",
        "kepano/flexoki-neovim", ]]

        -- opts = require("plugins.themes").new_tokyonight_options(),
    },

    {
        "rcarriga/nvim-notify",
        opts = require("plugins.notify").new_options(),
    },

    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("plugins.alpha-nvim")
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("plugins.lualine")
        end,
    },

    {
        "shellRaining/hlchunk.nvim",
        opts = require("plugins.hlchunk").new_options(),
    },
    ------------------------------------------------
    ----      Language Functional ,          -------
    ------------------------------------------------
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("plugins.nvim-treesitter").setup()
        end,
    },
    ------------------------------------------------
    ----      Windows Manager
    ------------------------------------------------
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("plugins.toggleterm").setup()
        end,
    },
    ------------------------------------------------
    ----      Fuzz Finder Plugins
    ------------------------------------------------
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-telescope/telescope-ui-select.nvim" },
        config = function()
            require("plugins.telescope").setup()
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "telescope.nvim" },
        build = "make",
        config = function()
            require("telescope").load_extension("fzf")
        end,
    },
    ------------------------------------------------
    ----      Misc Helper Plugins
    ------------------------------------------------
    {
        "nvim-neo-tree/neo-tree.nvim", -- directory browser
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        opts = require("plugins.neo-tree").new_options(),
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            require("plugins.ts-context-comment").setup()
        end,
    },
    {
        "b3nj5m1n/kommentary",
        config = function()
            require("plugins.kommentary").setup()
        end,
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            require("plugins.autopairs").setup()
        end,
    },

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = require("plugins.flash").new_options(),
    },
    ----------------------------------------------------------------
    ----      Completion , Diagnostics , Snippets,  LSP
    ----------------------------------------------------------------

    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        config = function()
            require("plugins.luasnip").setup()
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        config = function()
            require("plugins.cmp").setup()
        end,
        dependencies = {
            { "hrsh7th/cmp-buffer" },       -- buffer completion plugin
            { "hrsh7th/cmp-path" },         -- path completion plugin
            { "hrsh7th/cmp-cmdline" },
            { "saadparwaiz1/cmp_luasnip" }, -- completete for snippets
            { "hrsh7th/cmp-nvim-lsp" },     -- lsp

            { "windwp/nvim-autopairs" },    -- for auto complete pairs
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("plugins.lspconfig").setup()
        end,
    },
    { -- null lsp
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("plugins.null-ls").setup()
        end,
    },
    { -- lsp_signature
        "ray-x/lsp_signature.nvim",
        opts = require("plugins.lsp_signature").new_options(),
    },
    ----------------------------------------------------------------
    ----      Dap Debugger
    ----------------------------------------------------------------
    {
        "mfussenegger/nvim-dap",
        dependencies = "nvim-neotest/nvim-nio",
        config = function()
            require("plugins.dap").setup()
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-dap",
        opts = require("plugins.dap-ui").new_options(),
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = "nvim-dap",
        opts = require("plugins.dap-virtual-text").new_options(),
    },
    ----------------------------------------------------------------
    ----      Unit Test
    ----------------------------------------------------------------
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-go",
            "rouge8/neotest-rust",
        },
        config = function()
            require("plugins.neotest").setup()
        end,
    },

    ----------------------------------------------------------------
    ----      Git Plugins
    ----------------------------------------------------------------
    {
        "lewis6991/gitsigns.nvim",
        opts = require("plugins.gitsigns").new_options(),
    },

    ----------------------------------------------------------------
    ----      LLM
    ----------------------------------------------------------------
    --[[ {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, -- set this if you want to always pull the latest change
        opts = require("plugins.llm.avater").new_options(),
        build = "make",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        }
    }, ]]

    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("plugins.llm.codecompanion").setup()
        end
    },

    ----------------------------------------------------------------
    ----      Some Misc Plugin (but should placed at the end)
    ----------------------------------------------------------------
    {
        "xzbdmw/colorful-menu.nvim",
        config = function()
            require("colorful-menu").setup({ max_width = 64, })
        end
    },
    ---
    { "wakatime/vim-wakatime" },

    { -- which key
        "folke/which-key.nvim",
        config = function()
            require("plugins.which-key").setup()
        end,
    },

    -- With the release of Neovim 0.6 we were given the start of extensible core UI hooks
    {
        "stevearc/dressing.nvim",
        opts = require("plugins.dressing").new_options(),
    },
    -- markdown preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
}

require("lazy").setup(plugins, require("plugins.lazy").new_options())
