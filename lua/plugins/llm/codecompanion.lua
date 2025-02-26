local M = {}


M.setup = function()
    require("codecompanion").setup({
        adapters = {
            deepseek = function()
                return require("codecompanion.adapters").extend("deepseek", {
                    name = "deepseek",
                    env = {
                        api_key = function()
                            return os.getenv("OPENAPI_DEEPSEEK_KEY")
                        end,
                    },
                    schema = {
                        model = {
                            default = "deepseek-coder",
                        },
                    },
                })
            end,
            baidu_qianfan = function()
                return require("codecompanion.adapters").extend("deepseek", {
                    name = "baidu_qianfan",
                    url = "https://qianfan.baidubce.com/v2/chat/completions",
                    env = {
                        api_key = function()
                            return os.getenv("OPENAI_BAIDU_DEEPSEEK_KEY")
                        end
                    },
                })
            end,
            siliconflow = function()
                return require("codecompanion.adapters").extend("deepseek", {
                    name = "siliconflow",
                    url = "https://api.siliconflow.cn/v1/chat/completions",
                    env = {
                        api_key = function()
                            return os.getenv("OPENAI_SILICONFLOW_DEEPSEEK_KEY")
                        end,
                    },
                    schema = {
                        model = {
                            default = "deepseek-ai/DeepSeek-R1",
                            choices = {
                                ["deepseek-ai/DeepSeek-R1"] = { opts = { can_reason = true } },
                                "deepseek-ai/DeepSeek-V3",
                            },
                        },
                    },
                })
            end,
            aliyun_deepseek = function()
                return require("codecompanion.adapters").extend("deepseek", {
                    name = "aliyun_deepseek",
                    url = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
                    env = {
                        api_key = function()
                            return os.getenv("OPENAPI_ALIYUN_DEEPSEEK_KEY")
                        end,
                    },
                    schema = {
                        model = {
                            default = "deepseek-r1",
                            choices = {
                                ["deepseek-r1"] = { opts = { can_reason = true } },
                            },
                        },
                    },
                })
            end,
            -- 阿里云千问
            aliyun_qwen = function()
                return require("codecompanion.adapters").extend("openai_compatible", {
                    name = "aliyun_qwen",
                    env = {
                        url = "https://dashscope.aliyuncs.com", -- optional: default value is ollama url http://127.0.0.1:11434
                        api_key = function()
                            return os.getenv("OPENAPI_ALIYUN_QIANWEN_KEY")
                        end,
                        chat_url = "/compatible-mode/v1/chat/completions", -- optional: default value, override if different
                    },
                    schema = {
                        model = {
                            default = "qwen-omni-turbo-latest",
                        },
                    },
                })
            end,
            opts = {
                show_defaults = false,
            },
        },
        strategies = {
            chat = { adapter = "aliyun_qwen" },
            inline = { adapter = "aliyun_qwen" },
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
