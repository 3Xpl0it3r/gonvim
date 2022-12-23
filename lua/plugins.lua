local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

------------------------------------------------
----      Bootstrap, AutoCompile Packer,
------------------------------------------------
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = vim.fn.system({
		"git",
		"clone",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	vim.api.nvim_command("packadd packer.nvim")
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerInstall
  augroup end
]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

------------------------------------------------
----      Config Packer Some Behavior
------------------------------------------------
packer.init({
	max_jobs = 50,
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

------------------------------------------------
----      Packer Manager Plugins
------------------------------------------------
return require("packer").startup(function()
	use("wbthomason/packer.nvim") -- Packer can manage itselfplugin

	------------------------------------------------
	----      ColorsTheme , UI               -------
	------------------------------------------------
	use({ -- colorstheme
		"folke/tokyonight.nvim",
		config = function()
			require("conf.themes")
		end,
	})
	use({
		"rcarriga/nvim-notify",
		config = function()
			require("conf.notify").setup()
		end,
	})
	use({
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({ default = true })
		end,
	})

	use({ --- alpha is a fast and fully customizable greeter for neovim.
		"goolord/alpha-nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("conf.dashboard")
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			require("conf.lualine")
		end,
	})

	use({
		"stevearc/aerial.nvim",
		config = function()
			require("conf.aerial").setup()
		end,
	})

	use({
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("conf.trouble").setup()
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("conf.nvim-treesitter").setup()
		end,
	})
	--[[ use({
		"akinsho/bufferline.nvim",
		tag = "*",
		config = function()
			require("conf.bufferline").setup()
		end,
		requires = "nvim-tree/nvim-web-devicons",
	}) ]]

	------------------------------------------------
	----      Windows Manager
	------------------------------------------------
	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
		config = function()
			require("conf.toggleterm").setup()
		end,
	})

	------------------------------------------------
	----      Fuzz Finder Plugins
	------------------------------------------------
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-telescope/telescope-ui-select.nvim" },
		config = function()
			require("conf.telescope").setup()
		end,
	})
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		after = { "telescope.nvim" },
		run = "make",
		config = function()
			require("telescope").load_extension("fzf")
		end,
	})

	------------------------------------------------
	----      Misc Helper Plugins
	------------------------------------------------
	use({
		"nvim-neo-tree/neo-tree.nvim", -- directory browser
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("conf.neo-tree").setup()
		end,
	})

	use({
		"JoosepAlviste/nvim-ts-context-commentstring",
	})

	use({
		"b3nj5m1n/kommentary",
		config = function()
			require("conf.kommentary").setup()
		end,
	})

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("conf.autopairs").setup()
		end,
	})

	use({
		"phaazon/hop.nvim",
		branch = "v2",
		config = function()
			require("conf.hop").setup()
		end,
	})

	----------------------------------------------------------------
	----      Completion , Diagnostics , Snippets,  LSP
	----------------------------------------------------------------
	use({
		"hrsh7th/nvim-cmp",
		config = function()
			require("conf.cmp").setup()
		end,
		requires = {
			{ "hrsh7th/cmp-path" }, -- path completion plugin
			{ "hrsh7th/cmp-buffer" }, -- buffer completion plugin
			{ "hrsh7th/cmp-nvim-lsp" }, -- lsp
			-- snippet support
			{
				"L3MON4D3/LuaSnip",
				config = function()
					require("conf.luasnip").setup()
				end,
			},
			{ "saadparwaiz1/cmp_luasnip" }, -- completete for snippets
		},
	})
	use({
		"neovim/nvim-lspconfig",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("conf.lspconfig").setup()
		end,
	})
	use({ -- rust lsp
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("conf.null-ls").setup()
		end,
	})
	use({ -- lsp_signature
		"ray-x/lsp_signature.nvim",
		config = function()
			require("conf.lsp_signature").setup()
		end,
	})

	----------------------------------------------------------------
	----      Dap Debugger
	----------------------------------------------------------------
	use({
		"michaelb/sniprun",
		run = "bash ./install.sh",
		config = function()
			require("conf.sniprun").setup()
		end,
	})
	use({
		"mfussenegger/nvim-dap",
		config = function()
			require("conf.dap").setup()
		end,
	})
	use({
		"rcarriga/nvim-dap-ui",
		after = "nvim-dap",
		module = "dapui",
		config = function()
			require("conf.dap-ui").setup()
		end,
	})
	use({
		"theHamsta/nvim-dap-virtual-text",
		after = "nvim-dap",
		config = function()
			require("conf.dap-virtual-text")
		end,
	})

	----------------------------------------------------------------
	----      Unit Test
	----------------------------------------------------------------
	use({
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-go",
			"rouge8/neotest-rust",
		},
		config = function()
			require("conf.neotest").setup()
		end,
	})

	----------------------------------------------------------------
	----      Git Plugins
	----------------------------------------------------------------
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("conf.gitsigns").setup()
		end,
	})

	----------------------------------------------------------------
	----      Some Misc Plugin (but should placed at the end)
	----------------------------------------------------------------
	use({ "wakatime/vim-wakatime" }) -- wakatime

	use({ -- which key
		"folke/which-key.nvim",
		config = function()
			require("conf.which-key").setup()
		end,
	})
	-- With the release of Neovim 0.6 we were given the start of extensible core UI hooks
	use({
		"stevearc/dressing.nvim",
		config = function()
			require("conf.dressigns").setup()
		end,
	})

	--  Automatically set up your configuration after cloning packer.nvim
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
