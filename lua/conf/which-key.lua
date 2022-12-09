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
		["n"] = { "<cmd>Neotree toggle reveal<CR>", "DirExploer" },
		["q"] = { "<cmd>q!<CR>", "Quit" },

		-- code runner
		c = {
			name = "+Code",
			a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "CodeAction" },
			c = { "<cmd>TroubleToggle<CR>", "Problems" },
			r = { "<cmd>lua require'sniprun'.run()<cr>", "SnipRun" },
		},

		-- dap debug
		d = {
			name = "+Debug",
			-- mapping all in conf/dap.lua
		},

		-- git information
		g = {
			name = "+Git",
			b = { '<cmd>lua require"gitsigns".blame_line{}<CR>', "Blame" },
			d = { '<cmd>lua require"gitsigns".diffthis("~")<CR>', "Diff" },
			p = { '<cmd>lua require"gitsigns".preview_hunk()<CR>', "preview(Hunk)" },
			r = { '<cmd>lua require"gitsigns".reset_hunk()<CR>', "Reset(Hunk)" },
			R = { '<cmd>lua require"gitsigns".reset_buffer()<CR>', "Reset(Buffer)" },
			s = { '<cmd>lua require"gitsigns".stage_hunk()<CR>', "State hunk" },
			S = { '<cmd>lua require"gitsigns".stage_buffer()<CR>', "Stage(Buffer)" },
			u = { '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>}', "Undo Stage Hunk" },
			U = { '<cmd>lua require"gitsigns".reset_buffer_index()<CR>', "Reset(Buffer Index)" },
		},

		h = {
			name = "+Hop",
			l = {
				"<cmd>lua require('hop').hint_patterns({direction = require('hop.hint').HintDirection.AFTER_CURSOR,  current_line_only = true})<cr>",
				"Search Left Part",
			},
			h = {
				"<cmd>lua require('hop').hint_patterns({direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true})<cr>",
				"Search Right Part",
			},
			j = {
				"<cmd>lua require('hop').hint_patterns({direction = require('hop.hint').HintDirection.AFTER_CURSOR,  current_line_only = false})<cr>",
				"Search Below Part",
			},
			k = {
				"<cmd>lua require('hop').hint_patterns({direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = false})<cr>",
				"Search Upper Part",
			},
		},
		l = {
			name = "+Lsp",
			-- c = { "<cmd>lua CusLspActionRename.rename()<CR>", "Change(Rename)" },
			c = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Change(Rename)" },
			d = { "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", "Define" },
			D = { "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>", "TypeDefine" },
			e = { "<cmd>lua require('telescope.builtin').diagnostics()<cr>", "diagnostics" },
			f = { "<cmd>lua vim.lsp.buf.formatting({async=true})<cr>", "LspFormat" },
			i = { "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", "Interface" },
			r = { "<cmd>lua require('telescope.builtin').lsp_references()<cr>", "Reference" },
			s = { "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "Symbol(doc)" },
			S = { "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", "Symbol(workspace)" },
			o = { "<cmd>SymbolsOutline<cr>", "outline(Symbols-outline)" },
			-- O = { "<cmd>AerialToggle<cr>", "Outline(aerial)" },
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
			b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffer" },
			f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "FindFile" },
			g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "FindText" },
			p = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Project" },
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
		g = {
			name = "+Git",
			s = { '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>', "Stage(Hunk)" },
			r = { '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>', "Reset(Hunk)" },
		},
	}

	whichkey.setup(conf)
	whichkey.register(mapping_normal_mode, opts_normal)
	whichkey.register(mapping_visual_mode, opts_visual)
end

return M
