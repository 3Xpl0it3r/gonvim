local status_ok, _ = pcall(require, "cmp")
if not status_ok then
	require("utils.notify").notify("cmp not found!", "error", "Plugin")
	return
end
local status_luasnip_ok, luasnip = pcall(require, "luasnip")
if not status_luasnip_ok then
	return
end

local M = {}

local function config_nvim_cmp(cmp)
	local check_backspace = function()
		local col = vim.fn.col(".") - 1
		return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
	end
	local cmp_config = {
		apperance = {
			menu = {
				direction = "above",
			},
		},
		view = {
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
		formatting = {
			-- fields = { "kind", "abbr", "menu" },
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				local max_width = 0
				if max_width ~= 0 and #vim_item.abbr > max_width then
					vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. "…"
				end
				vim_item.kind = require("utils.icons").lspKind[vim_item.kind]
				vim_item.menu = ({
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
				vim_item.dup = ({
					buffer = 1,
					path = 1,
					nvim_lsp = 0,
					luasnip = 1,
				})[entry.source.name] or 0
				return vim_item
			end,
		},
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
		mapping = cmp.mapping.preset.insert({
			["<C-k>"] = cmp.mapping.select_prev_item(),
			["<C-j>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}),
			-- TODO: potentially fix emmet nonsense
			["<Tab>"] = cmp.mapping(function(fallback)
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif cmp.visible() then
					cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
					-- vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
				elseif check_backspace() then
					fallback()
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
		}),
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
	--[[ cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "cmdline" },
		}, {
			{ name = "path" },
		}),
	}) ]]

	-- disable autocompletion for guihua
	--[[ vim.cmd("autocmd FileType guihua lua require('cmp').setup.buffer { enabled = false }")
    vim.cmd("autocmd FileType guihua_rust lua require('cmp').setup.buffer { enabled = false }") ]]
	cmp.setup(cmp_config)
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
end

return M
