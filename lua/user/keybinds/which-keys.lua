local M = {}

M.normal = {
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
		c = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Change(Rename)" },
		d = { "<cmd>lua require('telescope.builtin').lsp_definitions({show_line=false})<cr>", "Define" },
		D = { "<cmd>lua require('telescope.builtin').lsp_type_definitions({show_line = false})<cr>", "TypeDefine" },
		e = { "<cmd>lua require('telescope.builtin').diagnostics()<cr>", "diagnostics" },
		f = { "<cmd>lua vim.lsp.buf.formatting({async=true})<cr>", "LspFormat" },
		i = { "<cmd>lua require('telescope.builtin').lsp_implementations({show_line = false})<cr>", "Interface" },
		r = { "<cmd>lua require('telescope.builtin').lsp_references({show_line = false})<cr>", "Reference" },
		s = {
			function()
				local aerial_avail, _ = pcall(require, "aerial")
				if aerial_avail then
					require("telescope").extensions.aerial.aerial()
				else
					require("telescope.builtin").lsp_document_symbols()
				end
			end,
			"Symbol(doc)",
		},
		S = {
			"<cmd>lua require('telescope.builtin').lsp_workspace_symbols(show_line = false)<cr>",
			"Symbol(workspace)",
		},
		u = { "<cmd>lua require('aerial').toggle()<cr>", "outline(aerial)" },
	},
	-- book marks
	m = {
		name = "+BookMarks",
		c = { "<cmd>delmarks 0-9a-z<cr>", "Compile" },
	},
	-- Plugin Manager
	p = {
		name = "+Plugins",
		c = { require("lazy").check, "Check" },
		C = { require("lazy").clean, "Clean" },
		h = { require("lazy").health, "Health" },
		i = { require("lazy").install, "Install" },
		s = { require("lazy").sync, "Sync" },
		u = { require("lazy").update, "Update" },
	},

	-- Search functions ,search file., seathc targs and other .....
	s = {
		name = "+Search",
		b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffer" },
		f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "FindFile" },
		g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "FindText" },
		p = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Project" },
		t = { "<cmd>lua require('telescope.builtin').treesitter()<cr>", "Treesitter" },
		u = { "<cmd>lua require('aerial').toggle()<cr>", "outline(aerial)" },
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

M.visual = {
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

return M
