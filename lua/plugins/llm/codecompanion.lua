local M = {}


M.setup = function()
    require("codecompanion").setup({
        adapters = {
            deepseek = function()
                return require("codecompanion.adapters").extend("deepseek", {
                    env = {
                        api_key = "DEEPSEEK_API_KEY",
                    },
                })
            end,
        },
        strategies = {
            chat = { adapter = "deepseek", },
            inline = { adapter = "deepseek" },
            agent = { adapter = "deepseek" },
        },
    })
end

return M
