local M = {}

local icons = require("ui.icons")

M.format = function(entry, item)
    -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number
    local completed_item = entry:get_completion_item()

    local detail = completed_item.detail
    if item.abbr:sub(-1) == "~" then -- if abbr contains '~', then remove it
        item.abbr = item.abbr:sub(1, -2)
    end

    if item_kind == 1 then -- Text
        item.concat = '"' .. item.abbr .. '"'
        item.offset = 1
    elseif item_kind == 2 or item_kind == 3 then -- Method or Function
        detail = detail:sub(5, #detail)          -- 保留detail 删除千4个字符, 也就是 func
    elseif item_kind == 5 then                   -- Field
    elseif item_kind == 6 then                   -- Variable
    elseif item_kind == 8 then                   -- Interface
    elseif item_kind == 9 then                   -- Module
    elseif item_kind == 21 then                  -- Constant
    elseif item_kind == 22 then                  -- Struct
        detail = " struct{}"
    end

    -- local size = vim.fn.strdisplaywidth(item.abbr) + vim.fn.strdisplaywidth(detail)
    if detail ~= nil then
        item.abbr = item.abbr .. " " .. detail
    end
    item.abbr = item.abbr .. " " .. detail
    item.kind = icons.go[item.kind] .. " "

    local highlights_info = require("colorful-menu").cmp_highlights(entry)
    if highlights_info ~= nil then
        item.abbr_hl_group = highlights_info.highlights
        item.abbr = highlights_info.text
    end

    return item
end

return M
