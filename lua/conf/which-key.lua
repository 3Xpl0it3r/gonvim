local status_ok, _ = pcall(require, "which-key")
if not status_ok then
    require("utils.notify").notify("Plugin which_key is not existed", "error", "Plugin")
	return
end

local M = {}

function M.setup()
	local whichkey = require("which-key")

	local conf = {
		window = {
			border = "single", -- none, single, double, shadow
			position = "bottom", -- bottom, top
		},
		popup_mappings = {
			scroll_down = "<c-d>", -- binding to scroll down inside the popup
			scroll_up = "<c-u>", -- binding to scroll up inside the popup
		},
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "->", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
		layout = {
			height = { min = 4, max = 25 }, -- min and max height of the columns
			width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
			align = "left", -- align columns left, center or right
		},
		hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
		show_help = true, -- show help message on the command line when the popup is visible
		triggers = "auto", -- automatically setup triggers
		disable = {
			buftypes = {},
			filetypes = { "TelescopePrompt" },
		},
	}

	local opts_normal = {
		mode = "n", -- Normal mode
		prefix = "<leader>",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymapswhich
		nowait = false, -- use `nowait` when creating keymaps
	}

	local mapping_normal_mode = {
		-- most used functional quick-keys
		["~"] = { "<CMD>noh<CR>", "cancel hilght" },
		["!"] = { "<cmd>source ~/.config/nvim/init.lua<CR>", "ReloadConfig" },
		["f"] = { "<cmd>lua require'telescope.builtin'.find_files()<cr>", "FindFile" },
		["n"] = { "<cmd>NvimTreeToggle<CR>", "DirExploer" },
		["q"] = { "<cmd>q!<CR>", "Quit" },

		--[[ ["1"] = { "<cmd>lua require('bufferline').go_to_buffer(1, true)<cr>", "tab1" },
		["2"] = { "<cmd>lua require('bufferline').go_to_buffer(2, true)<cr>", "tab2" },
		["3"] = { "<cmd>lua require('bufferline').go_to_buffer(3, true)<cr>", "tab3" },
		["4"] = { "<cmd>lua require('bufferline').go_to_buffer(4, true)<cr>", "tab4" },
		["5"] = { "<cmd>lua require('bufferline').go_to_buffer(5, true)<cr>", "tab5" },
		["6"] = { "<cmd>lua require('bufferline').go_to_buffer(6, true)<cr>", "tab6" },
		["7"] = { "<cmd>lua require('bufferline').go_to_buffer(7, true)<cr>", "tab7" },
		["8"] = { "<cmd>lua require('bufferline').go_to_buffer(8, true)<cr>", "tab8" },
		["9"] = { "<cmd>lua require('bufferline').go_to_buffer(9, true)<cr>", "tab9" },
		["$"] = { "<cmd>lua require('bufferline').go_to_buffer(-1, true)<cr>", "tab$" }, ]]

		-- code runner
		c = {
			name = "+Code/Lsp",
			a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "CodeAction" },
			c = { "<cmd>TroubleToggle<CR>", "Problems" },
			r = { "<cmd>lua require'sniprun'.run()<cr>", "SnipRun" },
			t = {},
		},

		-- dap debug
		d = {
			name = "+Debug",
			-- mapping all in init-dap.lua
		},

		-- git information
		g = {
			name = "+Git",
			d = { '<cmd>lua require("gitsigns").diffthis("~")<CR>', "diff" },
			p = { "<cmd>Gitsigns preview_hunk<CR>", "preview" },
		},

		l = {
			name = "+Lsp",
			-- c = { "<cmd>lua CusLspActionRename.rename()<CR>", "Change(Rename)" },
			c = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Change(Rename)" },
			d = { "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", "Define" },
			D = { "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>", "TypeDefine" },
			e = { "<cmd>lua require('telescope.builtin').diagnostics()<cr>", "diagnostics" },
			f = { "<cmd>lua vim.lsp.buf.format({async=true})<cr>", "LspFormat" },
			i = { "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", "Interface" },
			r = { "<cmd>lua require('telescope.builtin').lsp_references()<cr>", "Reference" },
			s = { "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "Symbol(doc)" },
			S = { "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", "Symbol(workspace)" },
			o = { "<cmd>SymbolsOutline<cr>", "outline(Symbols-outline)" },
			O = { "<cmd>AerialToggle<cr>", "Outline(aerial)" },
		},
		-- Plugin Manager
		p = {
			name = "+Plugins",
			c = { "<cmd>PackerCompile<cr>", "Compile" },
			i = { "<cmd>PackerInstall<cr>", "Install" },
			s = { "<cmd>PackerSync<cr>", "Sync" },
			S = { "<cmd>PackerStatus<cr>", "Status" },
			u = { "<cmd>PackerUpdate<cr>", "Update" },
		},

		-- Search functions ,search file., seathc targs and other .....
		s = {
			name = "+Search",
			a = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffer" },
			b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffer" },
			f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "FindFile" },
			g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "FindText" },
			h = {
				"<cmd>lua require('hop').hint_patterns({direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = false})<cr>",
				"Hop(?)",
			},
			t = { "<cmd>lua require('telescope.builtin').treesitter()<cr>", "Treesitter" },
			u = { "<cmd>lua require('SymbolOutline<cr>", "Outline" },
		},

		-- unit test
		t = {
			name = "+UintTest",
			d = { '<cmd>lua require("neotest").diagnostic()<CR>', "diagnostic" },
			p = { '<cmd>lua require("neotest").output.open()<CR>', "print" },
			r = { '<cmd>lua require("neotest").run.run()<CR>', "Run" },
			R = { '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', "Run" },
			s = { '<cmd>lua require("neotest").summary.toggle()<CR>', "Summary" },
			S = { '<cmd>lua require("neotest").status.toggle()<CR>', "SingStatus" },
		},

		-- windows / misc
		w = {
			name = "+Windows",
			g = { "<cmd>lua toggleterm_wrapper_lazygit()<cr>", "lazygit" },
			n = { "<cmd>ToggleTerm <cr>", "terminal" },
			r = { "<cmd>lua toggleterm_wrapper_ranger()<cr>", "ranger" },
		},
	}
	local opts_visual = {
		mode = "v", -- Visual mode
		prefix = "<leader>",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymapswhich
		nowait = false, -- use `nowait` when creating keymaps
	}
	local mapping_visual_mode = {
		-- most used functional quick-keys
		["q"] = { "<cmd>q!<CR>", "Quit" },
		-- code runner
		c = {
			name = "+Code",
			r = { "<cmd>lua require'sniprun'.run('v')<cr>", "sniprun" },
		},
	}

	whichkey.setup(conf)
	whichkey.register(mapping_normal_mode, opts_normal)
	whichkey.register(mapping_visual_mode, opts_visual)
end

return M