local M = {}

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

M.key_bind = function(cmp)
	return {

		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-c>"] = cmp.mapping.complete(),
		-- ["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		-- TODO: potentially fix emmet nonsense
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				local entries = cmp.get_entries()
				if #entries > 0 and (#entries == 1 or entries[1].exact) then
					cmp.confirm({ select = true })
				elseif cmp.visible() then
					cmp.select_next_item()
				end
			elseif require("luasnip").expand_or_jumpable() then
				require("luasnip").expand_or_jump()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if require("luasnip").jumpable(-1) then
				require("luasnip").jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	}
end

return M
