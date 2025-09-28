local M = {}

local mod_cache = nil
local std_lib = nil

---@param custom_args go_dir_custom_args
---@param on_complete fun(dir: string | nil)
local function identify_go_dir(custom_args, on_complete)
    local cmd = { 'go', 'env', custom_args.envvar_id }
    vim.system(cmd, { text = true }, function(output)
        local res = vim.trim(output.stdout or '')
        if output.code == 0 and res ~= '' then
            if custom_args.custom_subdir and custom_args.custom_subdir ~= '' then
                res = res .. custom_args.custom_subdir
            end
            on_complete(res)
        else
            vim.schedule(function()
                vim.notify(
                    ('[gopls] identify ' .. custom_args.envvar_id .. ' dir cmd failed with code %d: %s\n%s'):format(
                        output.code,
                        vim.inspect(cmd),
                        output.stderr
                    )
                )
            end)
            on_complete(nil)
        end
    end)
end

---@return string?
local function get_std_lib_dir()
    if std_lib and std_lib ~= '' then
        return std_lib
    end

    identify_go_dir({ envvar_id = 'GOROOT', custom_subdir = '/src' }, function(dir)
        if dir then
            std_lib = dir
        end
    end)
    return std_lib
end

---@return string?
local function get_mod_cache_dir()
    if mod_cache and mod_cache ~= '' then
        return mod_cache
    end

    identify_go_dir({ envvar_id = 'GOMODCACHE' }, function(dir)
        if dir then
            mod_cache = dir
        end
    end)
    return mod_cache
end


---@param fname string
---@return string?
local function get_root_dir(fname)
    if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
        local clients = vim.lsp.get_clients({ name = 'gopls' })
        if #clients > 0 then
            return clients[#clients].config.root_dir
        end
    end
    if std_lib and fname:sub(1, #std_lib) == std_lib then
        local clients = vim.lsp.get_clients({ name = 'gopls' })
        if #clients > 0 then
            return clients[#clients].config.root_dir
        end
    end
    return vim.fs.root(fname, 'go.work') or vim.fs.root(fname, 'go.mod') or vim.fs.root(fname, '.git')
end

M.gopls = {
    cmd = { "gopls", "serve", "-debug=localhost:8098" },
    filetypes = { "go", "gomod" },
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        get_mod_cache_dir()
        get_std_lib_dir()
        -- see: https://github.com/neovim/nvim-lspconfig/issues/804
        on_dir(get_root_dir(fname))
    end,
    settings = {
        gopls = {
            symbolStyle = "Full", -- Full| Dynamic | Package
            ------------------------------------------------
            ----      Analyses Setting
            ------------------------------------------------
            analyses = {
                unusedparams = true,
                unreachable = true,
                fillstruct = true,
            },
            ------------------------------------------------
            ----      Complete Setting
            ------------------------------------------------
            usePlaceholders = true, -- placeholders enables placeholders for function parameters or struct fields in completion responses.
            -- completionBudget = "0ms", -- completionBudget is the soft latency goal for completion requests
            matcher = "Fuzzy",      -- matcher sets the algorithm that is used when calculating completion candidates. CaseInsensitive | CaseSensitive | Fuzzy
            completeUnimported = true,
            deepCompletion = true,  -- If true, this turns on the ability to return completions from deep inside relevant entities, rather than just the locally accessible ones.
            -- experimentalWatchedFileDelay = "10ms"

            ------------------------------------------------
            ----      Inlayhint
            ------------------------------------------------
            hints = {
                assignVariableTypes = true,    -- i/* int*/, j/* int*/ := 0, len(r)-1
                compositeLiteralFields = true, -- {/*in: */"Hello, world", /*want: */"dlrow ,olleH"}
                compositeLiteralTypes = true,  -- /*struct{ in string; want string }*/{"Hello, world", "dlrow ,olleH"},
                constantValues = true,         -- KindNone   Kind = iota/* = 0*/
                functionTypeParameters = true, -- myFoo/*[int, string]*/(1, "hello")
                parameterNames = true,         -- parseInt(/* str: */ "123", /* radix: */ 8)
                rangeVariableTypes = true,     -- for k/* int*/, v/* string*/ := range []string{} {
            },
        },
    },
    single_file_support = true,
}

M.golangci_lint_ls = {
    cmd = { "golangci-lint-langserver" },
    init_options = {
        command = { "golangci-lint", "run", "--out-format", "json" },
    },
    filetypes = { "go", "gomod", ".git", ".golangci.yaml" },
    single_file_support = true,
}

return M
