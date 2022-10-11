local status_ok, _ = pcall(require, "null-ls")
if not status_ok then
    require("utils.notify").notify("Plugin null-ls is not existed", "error", "Plugin")
    return
end




local function shell_command_toggle_wrapper(cus_cmd)
    local __Terminal = require("toggleterm.terminal").Terminal
    local cmd_termal = __Terminal:new({
        cmd = cus_cmd .. '&& read -n 1 -s  "[Press Key to continue]" && exec true',
        direction = "float",
        float_opts = {
            border = "single",
        }
    })
    cmd_termal:toggle()
end

local code_actions_rust = {
    method = require("null-ls").methods.CODE_ACTION,
    filetypes = { "rust" },
    generator = {
        fn = function(_)
            return {
                {
                    title = "Cargo Check",
                    action = function()
                        shell_command_toggle_wrapper("cargo check")
                    end
                },
                {
                    title = "Cargo Build",
                    action = function()
                        shell_command_toggle_wrapper("cargo build")
                    end
                },
                {
                    title = "Cargo Run",
                    action = function()
                        shell_command_toggle_wrapper("cargo run")
                    end
                }
            }
        end
    }
}


local code_actions_golang = {
    method = require("null-ls").methods.CODE_ACTION,
    filetypes = { "go" },
    generator = {
        fn = function(context)
            return {
                {
                    title = "Import Packages",
                    action = function()
                        local get_pkgs = function()
                            local results = {}
                            local list_pkg = io.popen("gopkgs"):read("*all")
                            for line in list_pkg:gmatch("[^\n\r]+") do
                                table.insert(results, line)
                            end
                            return results
                        end
                        local import_position = -1
                        local pkg_position = -1
                        for index, value in ipairs(context["content"]) do
                            local find = string.find(value, "import")
                            if find then
                                import_position = index
                                break
                            end
                            if pkg_position == -1 then
                                local find_pkg = string.find(value, "package")
                                if find_pkg then
                                    pkg_position = index
                                end
                            end
                        end
                        local postion = import_position
                        local no_import = false
                        if postion == -1 then
                            no_import = true
                            postion = pkg_position
                        end
                        vim.ui.select(get_pkgs(), { prompt = "Import Packages" }, function(choice)
                            if not choice then
                                return
                            end
                            vim.ui.input({ prompt = "Alias PkgName" }, function(input)
                                local newline = nil
                                if input then
                                    newline = "\t" .. input .. "\"" .. choice .. "\""
                                else
                                    newline = "\t" .. "\"" .. choice .. "\""
                                end
                                if not no_import then
                                    vim.api.nvim_buf_set_lines(0, postion, postion, false, { newline })
                                else
                                    vim.api.nvim_buf_set_lines(0, postion, postion, false, { "import(", newline, ")" })
                                end
                                vim.lsp.buf.format({ async = true })
                            end)
                        end)
                    end
                },
                {
                    title = "Vendor",
                    action = function(_)
                        shell_command_toggle_wrapper("go mod vendor")
                    end
                },
            }
        end
    }
}

local M = {}

local function config_null_ls(null_ls)
    local opts = {
        cmd = { "nvim" },
        debounce = 250,
        debug = false,
        default_timeout = 5000,
        diagnostic_config = nil,
        diagnostics_format = "#{m}",
        fallback_severity = vim.diagnostic.severity.ERROR,
        log_level = "warn",
        notify_format = "[null-ls] %s",
        on_attach = nil,
        on_init = nil,
        on_exit = nil,
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git", "go.mod", "Cargo.toml"),
        sources = nil,
        update_in_insert = false,
    }
    null_ls.setup(opts)
end

function M.setup()
    local null_ls = require("null-ls")
    null_ls.register(code_actions_golang)
    null_ls.register(code_actions_rust)
    config_null_ls(null_ls)
end

return M
