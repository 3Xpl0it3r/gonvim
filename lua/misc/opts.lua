-- setup space as leader key

local options = {
	fileencoding = "utf-8", -- the encoding written to a file
	-- disable create backup files
	backup = false, -- creates a backup filemis
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	swapfile = false, -- creates a swapfile

	-- samller updatetime
	updatetime = 300, -- faster completion (4000ms default)
	timeoutlen = 150, -- time to wait for a mapped sequence to complete (in milliseconds)

	-- for auto complete option,
	completeopt = { "menuone", "noselect", "noinsert", "menu" }, -- mostly just for cmp

	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	cmdheight = 1, -- keep status bar position close to bottom
	conceallevel = 0, -- so that `` is visible in markdown files
	hlsearch = true, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	mouse = "", -- disable mouse completely
	pumheight = 10, -- pop up menu height
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	showtabline = 0, -- [0: never show, 1: if has more than 2tabs , 2 : always]
	smartcase = true, -- smart case
	smartindent = true, -- make indenting smarter again
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	termguicolors = true, -- set term gui colors (most terminals support this)
	undofile = true, -- enable persistent undo
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 4, -- the number of spaces inserted for each indentation
	tabstop = 4, -- insert 2 spaces for a tab
	cursorline = true, -- highlight the current line
	cursorcolumn = false, -- cursor column.
	number = true, -- set numbered lines
	relativenumber = true, -- set relative numbered lines
	numberwidth = 4, -- set number column width to 2 {default 4}
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	colorcolumn = "160", -- always show the sign column, otherwise it would shift the text each time
	wrap = true, -- display lines as one long line
	scrolloff = 4, -- keep 8 height offset from above and bottom
	sidescrolloff = 4, -- keep 8 width offset from left and right
	foldmethod = "expr", -- fold with nvim_treesitter
	foldexpr = "nvim_treesitter#foldexpr()",
	foldenable = false, -- no fold to be applied when open a file
	foldlevel = 99, -- if not set this, fold will be everywhere
	spell = false, -- add spell support
	spelllang = { "en_us" }, -- support which languages?
	diffopt = "vertical,filler,internal,context:4", -- vertical diff split view
	-- cscopequickfix="s-,c-,d-,i-,t-,e-",       -- cscope output to quickfix window
	confirm = false,

    -- shada = "\"0,'10,"
}

for k, v in pairs(options) do
	vim.opt[k] = v
end


vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

