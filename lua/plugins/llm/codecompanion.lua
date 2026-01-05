local M = {}

local available_models = {
    "ZhipuAI/GLM-4.6",
    "Qwen/Qwen2.5-Coder-32B-Instruct",
    "MiniMax/MiniMax-M2",
}

local available_adapters = {
    modelscope = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
                url = "https://api-inference.modelscope.cn/v1",
                api_key = "OPENAI_API_KEY",
                chat_url = "/chat/completions",
            },
            schema = {
                model = {
                    default = "Qwen/Qwen2.5-Coder-32B-Instruct",
                },
            },
        })
    end
}


M.setup = function()
    require("codecompanion").setup({
        opts = {
            language = "Chinese",
        },
        strategies = {
            chat = {
                adapter = "modelscope",
            },
            inline = {
                adapter = "modelscope",
            },
            cmd = {
                adapter = "modelscope",
            }
        },
        adapters = {
            http = {
                modelscope = available_adapters["modelscope"]
            }
        },
    })
end

return M
