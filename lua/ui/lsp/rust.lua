local M = {}

M.icons = {
    -- 用到的
    Interface = "ⓘ",
    Function = "ⓕ", -- 󰊕
    Field = "ⓕ",
    Method = "ⓜ",
    Variable = "ⓥ",
    Constant = "ⓒ",
    Type = "Ⓣ",
    Struct = "Ⓣ",
    Class = "Ⓣ",
    Text = "󰉿", -- 主要是buffer和dictionary来源
    Keyword = "", -- lsp来源的go关键词，直接不用icon，类似golang
    Module = "ⓟ", -- 包名，用于方便导入第3方包
    Snippet = "",
    TypeParameter = "󰊄",
    Treesitter = "",     -- treesiter 补全的，不知道啥时候会用到，也不知道用啥icon，先放个空吧
    TabNine = "",

    -- 应该没用到的
    Constructor = "󰏿",
    Namespace = "󰌗",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Color = "󰏘",
    File = "󰈚",
    Property = "󰜢",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Event = "",
    Operator = "󰆕",
    Table = "",
    Object = "󰅩",
    Tag = "",
    Array = "[]",
    Boolean = "",
    Signature = "",
    Number = "",
    Null = "󰟢",
    Supermaven = "",
    String = "󰉿",
    Calendar = "",
    Watch = "󰥔",
    Package = "",
    Copilot = "",
    Codeium = "",
    Ripgrep = "",
    Dictionary = "󰉋",
}


return M
