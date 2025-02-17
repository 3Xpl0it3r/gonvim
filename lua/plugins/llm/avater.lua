local M = {}




M.new_options = function()
    return {

        provider = "openai",
        auto_suggestions_provider = "openai", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
        openai = {
            endpoint = "https://api.deepseek.com/v1",
            model = "deepseek-chat",
            timeout = 30000, -- Timeout in milliseconds
            temperature = 0,
            max_tokens = 4096,
        },
    }
end




return M
