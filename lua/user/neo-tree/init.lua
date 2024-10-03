local M = {}


local handlers_registry    = {
    rust = require("user.neo-tree.rust"),
}

local language_ext_mapping = {
    rs = "rust",
}


M.event_handlers = {
    -- delete files
    {
        event = "file_added",
        handler = function(args)
            local full_path = vim.fn.expand(args)
            local extension = vim.fn.fnamemodify(full_path, ":t:r")
            local base_name = vim.fn.fnamemodify(full_path, ":t")
            -- 意味着创建的文件没有扩展名，大概率是创建的目录,不需要经过handler处理
            if extension == base_name then
                return
            end

            vim.api.nvim_command("wincmd l")
            vim.api.nvim_command("edit " .. full_path)
            local langugae = vim.bo.filetype
            local handler = handlers_registry[langugae]
            if handler == nil then
                do return end
            end

            -- open new file in neo-tree will not trigger BufNewFile event, so here call add_template directly
            require("extensions.templates").add_template()

            vim.ui.input({ prompt = "Attach to module(y|Y)?" }, function(input)
                if input ~= nil and string.lower(input) == "y" or string.lower(input) == "yes" then
                    handler.on_added(full_path)
                end
            end)
        end
    },
    -- added file
    {
        event = "file_deleted",
        handler = function(args)
            local full_path = vim.fn.expand(args)
            local extension = vim.fn.fnamemodify(full_path, ":t:e")
            local base_name = vim.fn.fnamemodify(full_path, ":t")
            -- 意味着创建的文件没有扩展名，大概率是创建的目录,不需要经过handler处理
            if extension == base_name then
                return
            end

            local langugae = language_ext_mapping[extension]

            if langugae == nil then
                do return end
            end

            local handler = handlers_registry[langugae]
            if handler == nil then
                do return end
            end

            handler.on_delete(full_path)
        end
    },
}

return M
