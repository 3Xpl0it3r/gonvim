local status_ok, _ = pcall(require, "cmp")
if not status_ok then
	require("utils.notify").notify("cmp not found!", "error", "Plugin")
	return
end

local icons = require("ui.icons")

local M = {}

local formatting_style = {
	-- fields = { "kind", "abbr", "menu" },
	fields = { "abbr", "kind", "menu" },

	format = function(entry, item)
		local icon = icons.lspKind[item.kind]
		-- icon = icons.lspKind.Text and (" " .. icon .. " ") or icon
		local max_width = 64

		if item.menu ~= nil then
			item.menu = string.gsub(item.menu, "^%s+", "")

			if string.sub(item.menu, 1, string.len("(")) == "(" then
				item.menu = item.menu:sub(1, item.menu:find(")", 1, true))
			end
			if max_width ~= 0 and #item.menu > max_width then
				item.menu = string.sub(item.menu, 1, max_width - 1) .. "…"
			end
		else
			item.menu = ({
				nvim_lsp = "(LSP)",
				treesitter = "(TS)",
				emoji = "(Emoji)",
				path = "(Path)",
				calc = "(Calc)",
				cmp_tabnine = "(Tabnine)",
				vsnip = "(Snippet)",
				luasnip = "(Snippet)",
				buffer = "(Buffer)",
				spell = "(Spell)",
			})[entry.source.name]
		end

		item.kind = string.format("%s  %s", icon, icons.lspKind.Text and item.kind or " ")
		item.dup = ({
			buffer = 1,
			path = 1,
			nvim_lsp = 1,
			luasnip = 1,
		})[entry.source.name] or 0
		return item
	end,
}

local function config_nvim_cmp(cmp)
	local cmp_config = {
		apperance = {
			menu = {
				direction = "above",
			},
		},
		view = {
			entries = {
				follow_cursor = true,
			},
			-- entries = { name = 'custom', selection_order = 'near_cursor' }
		},
		preselect = cmp.PreselectMode.None,
		confirm_opts = {
			behavior = cmp.ConfirmBehavior.Insert,
			select = false,
		},
		completion = { keyword_length = 2 },
		experimental = {
			ghost_text = false,
			native_menu = false,
		},
		formatting = formatting_style,
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		sources = {
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
		},
		enabled = function()
			local context = require("cmp.config.context")
			if vim.api.nvim_get_mode().mode == "c" then
				return true
			else
				return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
			end
		end,
		mapping = cmp.mapping.preset.insert(require("user.keybinds.cmp").key_bind(cmp)),
	}

	-- Set configuration for specific filetype.
	local mis_file_types = { "markdown", "xml", "vim", "viminfo", "systemd" }
	for _, ftype in ipairs(mis_file_types) do
		cmp.setup.filetype(ftype, {
			sources = cmp.config.sources({
				{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
			}, {
				{ name = "buffer" },
				{ name = "path" },
				{ name = "nvim_lua" },
				{ name = "buffer" },
				{ name = "cmp_tabnine" },
				{ name = "spell" },
				{ name = "calc" },
				{ name = "emoji" },
				{ name = "treesitter" },
				{ name = "crates" },
			}),
		})
	end
	-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	cmp.setup.cmdline("?", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})

	-- disable autocompletion for guihua
	--[[ vim.cmd("autocmd FileType guihua lua require('cmp').setup.buffer { enabled = false }")
    vim.cmd("autocmd FileType guihua_rust lua require('cmp').setup.buffer { enabled = false }") ]]
	cmp.setup(cmp_config)
end

local function nvim_cmp_extend()
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	local cmp_status_ok, cmp = pcall(require, "cmp")
	if not cmp_status_ok then
		return
	end
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
end

local function config_highlight()
	local highlights = {
		PmenuThumb = { fg = "NONE", bg = "#4FC3F7" },
	}

	for k, v in pairs(highlights) do
		vim.api.nvim_set_hl(0, k, v)
	end
end

function M.setup()
	local cmp = require("cmp")
	config_nvim_cmp(cmp)
	config_highlight()
	nvim_cmp_extend()
end

return M
