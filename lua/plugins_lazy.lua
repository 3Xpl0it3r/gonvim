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

local plugins = {
	------------------------------------------------
	----      ColorsTheme , UI               -------
	------------------------------------------------
	{
		"folke/tokyonight.nvim",
		config = function()
			require("plugins.themes")
		end,
	},
	{ "catppuccin/nvim", as = "catppuccin" },
	{ "rebelot/kanagawa.nvim" },

	{
		"rcarriga/nvim-notify",
		config = function()
			require("plugins.notify").setup()
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({ default = true })
		end,
	},
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("plugins.lualine")
		end,
	},

	{
		"gen740/SmoothCursor.nvim",
		config = function()
			require("plugins.smoothcursor").setup()
		end,
	},
	------------------------------------------------
	----      Language Functional ,          -------
	------------------------------------------------
	{
		"stevearc/aerial.nvim",
		config = function()
			require("plugins.aerial").setup()
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("plugins.trouble").setup()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
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
		config = function()
			require("plugins.neo-tree").setup()
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
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
		"phaazon/hop.nvim",
		config = function()
			require("plugins.hop").setup()
		end,
	},
	----------------------------------------------------------------
	----      Completion , Diagnostics , Snippets,  LSP
	----------------------------------------------------------------
	{
		"hrsh7th/nvim-cmp",
		config = function()
			require("plugins.cmp").setup()
		end,
		dependencies = {
			{ "hrsh7th/cmp-path" }, -- path completion plugin
			{ "hrsh7th/cmp-buffer" }, -- buffer completion plugin
			{ "hrsh7th/cmp-nvim-lsp" }, -- lsp
			-- snippet support
			{
				"L3MON4D3/LuaSnip",
				config = function()
					require("plugins.luasnip").setup()
				end,
			},
			{ "saadparwaiz1/cmp_luasnip" }, -- completete for snippets
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
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("plugins.null-ls").setup()
		end,
	},
	{ -- lsp_signature
		"ray-x/lsp_signature.nvim",
		config = function()
			require("plugins.lsp_signature").setup()
		end,
	},
	{
		"lvimuser/lsp-inlayhints.nvim",
		branch = "anticonceal",
		config = function()
			require("plugins.inlayhints").setup()
		end,
	},
	----------------------------------------------------------------
	----      Dap Debugger
	----------------------------------------------------------------
	{
		"michaelb/sniprun",
		build = "bash ./install.sh",
		config = function()
			require("plugins.sniprun").setup()
		end,
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			require("plugins.dap").setup()
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = "nvim-dap",
		config = function()
			require("plugins.dap-ui").setup()
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = "nvim-dap",
		config = function()
			require("plugins.dap-virtual-text")
		end,
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
		config = function()
			require("plugins.gitsigns").setup()
		end,
	},
	----------------------------------------------------------------
	----      Some Misc Plugin (but should placed at the end)
	----------------------------------------------------------------
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
		config = function()
			require("plugins.dressigns").setup()
		end,
	},
	{
		"stevearc/dressing.nvim",
		config = function()
			require("plugins.dressigns").setup()
		end,
	},
}

local opts = {
	checker = {
		-- automatically check for plugin updates
		enabled = false,
		concurrency = nil, ---@type number? set to 1 to check for updates very slowly
		notify = true, -- get a notification when new updates are found
		frequency = 3600, -- check for updates every hour
	},
}

require("lazy").setup(plugins, opts)
