local M = {}


M.new_options = function()
    return {
        provider = "modelscope",
        providers = {
            modelscope = {
                __inherited_from = 'openai',
                endpoint = 'https://api-inference.modelscope.cn/v1/',
                api_key_name = 'OPENAI_API_KEY',
                model = 'Qwen/Qwen2.5-Coder-32B-Instruct',
            },
        },
    }
end




return M
