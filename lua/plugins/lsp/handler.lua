local M = {}

local icons = require("ui.icons")

vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
        local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "cursor",
        }
        vim.diagnostic.open_float(nil, opts)
    end,
})

local function definition_split()
    vim.lsp.buf.definition({
        on_list = function(options)
            -- if there are multiple items, warn the user
            if #options.items > 1 then
                vim.notify('Multiple items found, opening first one', vim.log.levels.WARN)
            end

            -- Open the first item in a vertical split
            local item = options.items[1]
            local cmd = 'vsplit +' .. item.lnum .. ' ' .. item.filename .. '|' .. 'normal ' .. item.col .. '|'

            vim.cmd(cmd)
        end,
    })
end

M.setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
        { name = "DiagnosticSignWarn",  text = icons.diagnostics.Warn },
        { name = "DiagnosticSignHint",  text = icons.diagnostics.Hint },
        { name = "DiagnosticSignInfo",  text = icons.diagnostics.Info },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        virtual_text = {
            prefix = icons.misc.fake, -- Could be '●', '▎', 'x', '■' '◉ '
        },
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }
    vim.diagnostic.config(config)
    vim.lsp.handlers["$/progress"] = require("utils.notify").lsp_status_update
end

local function lsp_keymaps(bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", definition_split, { desc = "Goto Definition (split)" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>", { noremap = true })
    vim.keymap.set("n", "gr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", { noremap = true })
    vim.keymap.set("n", "gf", vim.lsp.buf.format, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)

    -- vim.keymap.set("n", "<space>rn", "<cmd>lua CusLspActionRename.rename()<CR>", bufopts)
    vim.keymap.set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
end

local function lsp_highlight_document(client)
    -- Set autocommands conditional on server_capabilities
    local status_ok, illuminate = pcall(require, "illuminate")
    if not status_ok then
        return
    end
    illuminate.on_attach(client)
    -- end
end

M.on_attach = function()
    return function(client, bufnr)
        -- disable formatting for LSP clients as this is handled by null-ls
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
        local lsp_signature_avail, lsp_signature = pcall(require, "lsp_signature")
        if lsp_signature_avail then
            lsp_signature.on_attach()
        end

        -- for codelens
        --[[ if client.supports_method("textDocument/codeLens") then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({"BufEnter", "CursorHold", "InsertLeave"}, {
                buffer = buffer,
                callback = vim.lsp.codelens.refresh,
            })
        end ]]

        lsp_keymaps(bufnr)
        lsp_highlight_document(client)
    end
end

M.capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        },
    }
    capabilities.textDocument.codeAction = {
        dynamicRegistration = true,
        codeActionLiteralSupport = {
            codeActionKind = {
                valueSet = (function()
                    local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
                    table.sort(res)
                    return res
                end)(),
            },
        },
    }
    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if not status_ok then
        return
    end
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    return capabilities
end

return M
