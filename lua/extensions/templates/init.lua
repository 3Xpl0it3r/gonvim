local M = {}


local tpl_registry = {
    rust = require("extensions.templates.rust")
}

local insert_text = function(buf_nr, template)
    template = template:gsub("\\n", "\n")

    local lines = vim.split(template, "\n")

    vim.api.nvim_buf_set_lines(buf_nr, 0, -1, false, lines)
end

local add_template = function()
    local language = vim.bo.filetype
    local tpl_getter = tpl_registry[language]
    if tpl_getter == nil then
        do return end
    end

    insert_text(vim.api.nvim_get_current_buf(), tpl_getter.get_template())
    vim.cmd("w!")
end



M.setup = function()
    local group = vim.api.nvim_create_augroup("_template_autogroup", { clear = true })
    vim.api.nvim_create_autocmd('BufNewFile', {
        group = group,
        callback = function()
            add_template()
        end
    })
end


M.add_template = function()
    add_template()
end

return M
