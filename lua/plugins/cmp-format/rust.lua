-- some code is copied from https://github.com/xzbdmw/colorful-menu.nvim/blob/master/lua/colorful-menu/languages/rust.lua
--
local M = {}


M.format = function(entry, item)
    item.menu = nil
    item.kind = require("ui.lsp.go").icons[item.kind] .. " "

    vim.cmd('highlight cmpitemkindfunction guifg=#cb6460')
    vim.cmd('highlight cmpitemkindinterface guifg=#659462')
    vim.cmd('highlight cmpitemkindconstant guifg=#bd805c')
    vim.cmd('highlight cmpitemkindvariable guifg=#bd805c')
    vim.cmd('highlight cmpitemkindstruct guifg=#6089ef')
    vim.cmd('highlight cmpitemkindclass guifg=#6089ef')
    vim.cmd('highlight cmpitemkindmethod guifg=#a25553')
    vim.cmd('highlight cmpitemkindfield guifg=#bd805c')

    return item
end

return M
