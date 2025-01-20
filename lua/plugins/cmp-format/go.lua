local M = {}


M.format = function(entry, item)
    item.menu = nil
    item.kind = require("ui.lsp.go").icons[item.kind] .. " "

    vim.cmd('highlight CmpItemKindFunction guifg=#CB6460')
    vim.cmd('highlight CmpItemKindInterface guifg=#659462')
    vim.cmd('highlight CmpItemKindConstant guifg=#BD805C')
    vim.cmd('highlight CmpItemKindVariable guifg=#FFA066') -- 
    vim.cmd('highlight CmpItemKindStruct guifg=#6089EF')
    vim.cmd('highlight CmpItemKindClass guifg=#6089EF')
    vim.cmd('highlight CmpItemKindMethod guifg=#A25553')
    vim.cmd('highlight CmpItemKindField guifg=#E6C384')
    return item
end

return M
