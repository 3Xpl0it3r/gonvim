local icons = require("ui.icons")
local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	require("utils.notify").notify("Plugin alpha is not existed", "error", "Plugin")
	return
end

local M = {}

local function footer()
	-- NOTE: requires the fortune-mod package to work
	local plugins = #vim.tbl_keys(require("lazy").plugins())
	-- local plugins = #vim.tbl_keys(packer_plugins)

	local v = vim.version()
	local datetime = os.date(icons.dashboard.date .. " %Y-%m-%d  " .. icons.dashboard.time .. " %H:%M:%S")

	local platform = vim.fn.has("win32") == 1 and icons.os.windows
		or vim.fn.has("macunix") == 1 and icons.os.macos
		or icons.os.linux

	return string.format(" %d   v%d.%d.%d %s  %s", plugins, v.major, v.minor, v.patch, platform, datetime)
end

M.custom_actions = {
	new_file = function()
		vim.ui.input({
			prompt = "New Filename(Default demo)",
			highlight = function()
				return { fg = "blue", bg = "white" }
			end,
		}, function(fname)
			if fname == nil or fname == "" then
                -- 如果没有指定应该退出nvim
                vim.cmd(":qall!")
			end
			vim.fn.system("touch " .. fname)
			vim.cmd(":e " .. fname)
		end)
	end,
}

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = require("ui.lego").lego()
dashboard.section.buttons.val = {
	dashboard.button("f", icons.dashboard.find .. "  Find file", ":Telescope find_files <CR>"),
	-- dashboard.button("n", icons.dashboard.file .. "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button(
		"n",
		icons.dashboard.file .. "  New file",
		":lua require'plugins.alpha-nvim'.custom_actions['new_file']() <CR>"
	),
	dashboard.button("p", icons.dashboard.project .. "  Find project", ":Telescope projects <CR>"),
	dashboard.button("r", icons.dashboard.recent .. "  Recently used files", ":Telescope oldfiles <CR>"),
	dashboard.button("g", icons.dashboard.text .. "  Find text", ":Telescope live_grep <CR>"),
	dashboard.button("c", icons.dashboard.config .. "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
	dashboard.button("q", icons.dashboard.quit .. "  Quit Neovim", ":qa<CR>"),
}

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)

return M
