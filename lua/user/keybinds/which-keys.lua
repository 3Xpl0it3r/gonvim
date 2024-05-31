local M = {}

M.normal = {
	-- most used functional quick-keys
	["~"] = { "<CMD>noh<CR>", "cancel hilght" },
	["!"] = { "<cmd>source ~/.config/nvim/init.lua<CR>", "ReloadConfig" },
	["f"] = { "<cmd>lua require'telescope.builtin'.find_files()<cr>", "FindFile" },
	["n"] = { "<cmd>Neotree toggle reveal<CR>", "DirExploer" },
	["q"] = { "<cmd>q!<CR>", "Quit" },
	-- test
	["z"] = { "<cmd>lua require'tsexample'.test()<cr>", "TestTS" },

	-- code runner
	c = {
		name = "+Code",
		-- asm  反汇编
		a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "CodeAction" },
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
		-- d = { '<cmd>lua require"gitsigns".diffthis("~")<CR>', "Diff" },
		p = { '<cmd>lua require"gitsigns".preview_hunk()<CR>', "preview(Hunk)" },
		r = { '<cmd>lua require"gitsigns".reset_hunk()<CR>', "Reset(Hunk)" },
		R = { '<cmd>lua require"gitsigns".reset_buffer()<CR>', "Reset(Buffer)" },
		--[[ s = { '<cmd>lua require"gitsigns".sedatage_hunk()<CR>', "State hunk" },
		S = { '<cmd>lua require"gitsigns".stage_buffer()<CR>', "Stage(Buffer)" }, ]]
		u = { '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>}', "Undo Stage Hunk" },
		U = { '<cmd>lua require"gitsigns".reset_buffer_index()<CR>', "Reset(Buffer Index)" },

		q = { '<cmd>lua require"extensions.git.init".quit()<CR>', "Quit" },

		d = { '<cmd>lua require"extensions.git.init".diff()<CR>', "Diff" },
		s = { '<cmd>lua require"extensions.git.init".status()<CR>', "Git status" },
		l = { '<cmd>lua require"extensions.git.init".history()<CR>', "Git History" },
		B = { '<cmd>lua require"extensions.git.init".branch()<CR>', "Git History" },
	},

	l = {
		name = "+Lsp",
		c = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Change(Rename)" },
		d = { "<cmd>lua require('telescope.builtin').lsp_definitions({show_line=false})<cr>", "Define" },
		D = { "<cmd>lua require('telescope.builtin').lsp_type_definitions({show_line = false})<cr>", "TypeDefine" },
		e = { "<cmd>lua require('telescope.builtin').diagnostics()<cr>", "diagnostics" },
		f = { "<cmd>lua vim.lsp.buf.format({async=true})<cr>", "LspFormat" },
		-- for inlay hints
		h = {
			"<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>",
			"Inlay Hints(nvim>=0.10)",
		},

		i = { "<cmd>lua require('telescope.builtin').lsp_implementations({show_line = false})<cr>", "Interface" },
		r = { "<cmd>lua require('telescope.builtin').lsp_references({show_line = false})<cr>", "Reference" },
		t = { "<cmd>lua require('telescope.builtin').diagnostics()<cr>", "Trouble" },
	},

	-- book marks
	m = {
		name = "+BookMarks",
		a = { "<cmd>lua require('extensions.bookmarks').add()<cr>", "Add BookMarks" },
		c = { "<cmd>lua require('extensions.bookmarks').clean_all()<cr>", "Clean All" },
		l = { "<cmd>lua require('extensions.bookmarks').actions()<cr>", "List Bookmarks" },
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
	},

	-- unit test
	t = {
		name = "+UintTest",
		-- Debug the neartest test(require nvim-dap and adapter support)
		d = { '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>', "Debug neartest" },
		-- run the nearest test
		r = { '<cmd>lua require("neotest").run.run()<CR>', "Run" },
		-- run the current file
		R = { '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', "Run" },
		s = { '<cmd>lua require("neotest").summary.toggle()<CR>', "Summary" },
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
