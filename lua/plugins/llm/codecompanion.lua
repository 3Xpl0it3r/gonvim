local M = {}


local qwen3 = {
    name = "deepseek",
    url = "https://api-inference.modelscope.cn/v1/",
    env = {
        api_key = function()
            return os.getenv("OPENAI_API_KEY")
        end,
    },
    schema = {
        model = {
            default = "Qwen/Qwen2.5-7B-Instruct"
        }
    }
}


M.setup = function()
    require("codecompanion").setup({
        adapters = {
            http = {
                modelscope = function()
                    require("codecompanion.adapters").extend("deepseek", qwen3)
                end
            }
        },
        strategies = {
            chat = {
                adapter = "deepseek",
            },
            inline = {
                adapter = "deepseek",
            },
            cmd = {
                adapter = "deepseek",
            }
        },
        opts = {
            language = "Chinese",
        },
        prompt_library = {
            ["My New Prompt"] = {
                strategy = "chat",
                description = "Some cool custom prompt you can do",
                prompts = {
                    {
                        role = "system",
                        content = "You are an experienced developer with Lua and Neovim",
                    },
                    {
                        role = "user",
                        content = "Can you explain why ...",
                    },
                },
            },
        },
    })
end

return M
