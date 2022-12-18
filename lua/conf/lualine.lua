local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	require("utils.notify").notify("Plugin lualine is not existed", "error", "Plugin")
	return
end

local getGitBranchName = function()
	local branchName = vim.b.gitBranchName or ""
	local icon = " "

	if branchName == "master" then
		icon = " "
	elseif string.find(string.lower(branchName), "fix") then
		icon = " "
		branchName = branchName:sub(5, -1)
	elseif string.find(string.lower(branchName), "feat") then
		icon = " "
		branchName = branchName:sub(6, -1)
	else
		icon = " "
	end
	if branchName == "" then
		return icon
	else
		return icon .. " " .. branchName
	end
end

-- Color table for highlights
local colors = require("utils.colors").custom

local mode_color = {
	n = colors.blue,
	i = colors.green,
	v = colors.red,
	[""] = colors.blue,
	V = colors.blue,
	c = colors.magenta,
	no = colors.red,
	s = colors.orange,
	S = colors.orange,
	[""] = colors.orange,
	ic = colors.yellow,
	R = colors.violet,
	Rv = colors.violet,
	cv = colors.red,
	ce = colors.red,
	r = colors.cyan,
	rm = colors.cyan,
	["r?"] = colors.cyan,
	["!"] = colors.red,
	t = colors.red,
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

-- Config
local config = {
	options = {
		icons_enabled = true,
		component_separators = "",
		section_separators = "",
		globalstatus = true,
		always_divide_middle = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
		theme = {
			normal = { c = { fg = colors.fg, bg = colors.bg } },
			inactive = { c = { fg = colors.fg, bg = colors.bg } },
		},
	},
	sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
	winbar = {
		lualine_a = {
			{
				"filetype",
				colored = true,
				icon_only = true,
			},
		},
		lualine_b = {
			{
				"filename",
				path = 1,
				color = { fg = "#FF9E3B", gui = "bold" },
				fmt = function(filename)
					return filename:gsub("/", " > ")
				end,
			},
		},
	},
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left({
	function()
		return "▊"
	end,
	color = { fg = colors.blue }, -- Sets highlighting of component
	padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left({
	"filetype",
	colored = true,
	icon_only = true,
	icon = { align = "right" },
	padding = { right = 0 },
})

ins_left({
	"filename",
	cond = conditions.buffer_not_empty,
	color = { fg = colors.magenta, gui = "bold" },
	file_status = false,
	symbols = {
		modified = "[+]",
		readonly = "[-]",
		unnamed = "[?]",
	},
})

ins_left({
	function()
		local mode_mapper = {
			["n"] = "三上悠亜",
			["no"] = "明日花キララ",
			["nov"] = "明日花キララ",
			["noV"] = "明日花キララ",
			["no"] = "明日花キララ",
			["niI"] = "三上悠亜",
			["niR"] = "三上悠亜",
			["niV"] = "三上悠亜",
			["nt"] = "三上悠亜",
			["v"] = "神宮寺ナオ",
			["vs"] = "神宮寺ナオ",
			["V"] = "神宮寺ナオ",
			["Vs"] = "神宮寺ナオ",
			[""] = "神宮寺ナオ",
			["s"] = "神宮寺ナオ",
			["s"] = "希崎ジェシカ",
			["S"] = "希崎ジェシカ",
			[""] = "希崎ジェシカ",
			["i"] = "七海ティナ",
			["ic"] = "七海ティナ",
			["ix"] = "七海ティナ",
			["R"] = "安齋らら",
			["Rc"] = "安齋らら",
			["Rx"] = "安齋らら",
			["Rv"] = "神宮寺ナオ",
			["Rvc"] = "神宮寺ナオ",
			["Rvx"] = "神宮寺ナオ",
			["c"] = "松下紗栄子",
			["cv"] = "七ツ森りり",
			["ce"] = "七ツ森りり",
			["r"] = "上原瑞穂",
			["rm"] = "竹内有紀",
			["r?"] = "美乃すずめ",
			["!"] = "斎藤あみり",
			["t"] = "斎藤あみり",
		}
		return string.format("< %s >", mode_mapper[vim.fn.mode()])
	end,
	color = { fg = colors.blue, gui = "bold" }, -- Sets highlighting of component
	padding = { left = 1, right = 1 }, -- We don't need space before this
})

ins_left({
	-- filesize component
	"filesize",
	cond = conditions.buffer_not_empty,
})

ins_left({ "location" })

ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

ins_left({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = " ", info = " ", hint = " " },
	diagnostics_color = {
		color_error = { fg = colors.red },
		color_warn = { fg = colors.yellow },
		color_info = { fg = colors.blue },
		color_hint = { fg = colors.green },
	},
	always_visible = true,
})

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left({
	function()
		return "%="
	end,
})

ins_left({
	-- mode component
	function()
		return vim.fn.has("win32") == 1 and "" or vim.fn.has("macunix") == 1 and "" or ""
	end,
	color = function()
		-- auto change color according to neovims mode
		return { fg = mode_color[vim.fn.mode()] }
	end,
	padding = { right = 1 },
})
ins_left({
	function()
		return os.date("%Y-%m-%d %H-%M-%S")
	end,
	color = { fg = colors.green },
})

ins_right({
	"branch",
	icon = getGitBranchName(),
	color = { fg = colors.violet, gui = "bold" },
})

ins_right({
	"diff",
	-- Is it me or the symbol for modified us really weird
	symbols = { added = "  ", modified = " ", removed = " " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.orange },
		removed = { fg = colors.red },
	},
	cond = conditions.hide_in_width,
})

ins_right({
	function()
		return "%="
	end,
})

ins_right({
	-- Lsp server name .
	function()
		local msg = "LS Inactive"
		local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
		local clients = vim.lsp.get_active_clients()
		if next(clients) == nil then
			return msg
		end
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
				if (client.name == "null-ls") == false then
					return client.name
				end
			end
		end
		return msg
	end,
	icon = "  LSP:",
	color = function()
		local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
		local clients = vim.lsp.get_active_clients()
		if next(clients) == nil then
			return { fg = colors.violet, gui = "bold" }
		end
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
				return { fg = colors.green, gui = "bold" }
			end
		end
		return { fg = colors.violet, gui = "bold" }
	end,
	-- color = { fg = next(vim.lsp.get_active_clients()) == nil and colors.violet or colors.green , gui = 'bold' },
})

-- Add components to right sections
ins_right({
	"o:encoding", -- option component same as &encoding in viml
	fmt = string.upper, -- I'm not sure why it's upper case either ;)
	cond = conditions.hide_in_width,
	color = { fg = colors.green, gui = "bold" },
})

ins_right({
	function()
		return "▊"
	end,
	color = { fg = colors.blue },
	padding = { left = 1 },
})

-- Now don't forget to initialize lualine
lualine.setup(config)
