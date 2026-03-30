local status_ok, _ = pcall(require, "nvim-treesitter")
if not status_ok then
    require("utils.notify").notify("Plugin nvim-treesitter is not existed", "error", "Plugin")
    return
end

local M = {}

local function config_nvim_treesitter(ts)
    local parsers = {
        "bash",
        "comment",
        "css",
        "cpp",
        "dockerfile",
        "git_config",
        "gitcommit",
        "gitignore",
        "groovy",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        "json5",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rst",
        "rust",
        "scss",
        "ssh_config",
        "sql",
        "terraform",
        "typst",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
    }
    for _, parser in ipairs(parsers) do
        ts.install(parser)
    end
    local patterns = {}
    for _, parser in ipairs(parsers) do
        local parser_patterns = vim.treesitter.language.get_filetypes(parser)
        for _, pp in pairs(parser_patterns) do
            table.insert(patterns, pp)
        end
    end

    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

    vim.api.nvim_create_autocmd('FileType', {
        pattern = patterns,
        callback = function()
            vim.treesitter.start()
        end,
    })
end

function M.setup()
    config_nvim_treesitter(require("nvim-treesitter"))
end

return M
