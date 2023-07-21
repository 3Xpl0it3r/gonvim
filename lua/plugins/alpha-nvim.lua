local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	require("utils.notify").notify("Plugin alpha is not existed", "error", "Plugin")
	return
end

local function footer()
	-- NOTE: requires the fortune-mod package to work
	local plugins = #vim.tbl_keys(require("lazy").plugins())
	-- local plugins = #vim.tbl_keys(packer_plugins)

	local v = vim.version()
	local datetime = os.date(" %Y-%m-%d   %H:%M:%S")

	local platform = vim.fn.has("win32") == 1 and "" or vim.fn.has("macunix") == 1 and "" or ""

	return string.format(" %d   v%d.%d.%d %s  %s", plugins, v.major, v.minor, v.patch, platform, datetime)
end


local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = require("ui.lego").lego()
dashboard.section.buttons.val = {
	dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
	dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
	dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
	dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}


dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)
