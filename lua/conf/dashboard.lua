local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
    require("utils.notify").notify("Plugin alpha is not existed", "error", "Plugin")
    return
end

local dashboard     = require("alpha.themes.dashboard")
local icon_computer = {
    [[        _______________________________________        ]],
    [[       |,---"-----------------------------"---,|       ]],
    [[       ||___    16 bit....................    ||       ]],
    [[       ||====\ :HHHHHHHHHHHHHHHHHHHHHHHHHHH   ||       ]],
    [[       ||=====):H  _ ____   _(_)_ __ ___  H   ||       ]],
    [[       ||====/ :H | '_ \ \ / / | '_ ` _ \ H   ||       ]],
    [[       ||"""   :H | | | \ V /| | | | | | |H   ||       ]],
    [[       ||PORTFO:H |_| |_|\_/ |_|_| |_| |_|H   ||       ]],
    [[       ||      :HHHHHHHHHHHHHHHHHHHHHHHHHHH   ||       ]],
    [[       ||_____,_________________________,_____||       ]],
    [[       |)_____)-----.| /I\ATARI |.------(_____(|       ]],
    [[     //"""""""|_____|=----------=|______|"""""""\      ]],
    [[    // _| _| _| _| _| _| _| _| _| _| _| _| _| _| \     ]],
    [[   // ___| _| _| _| _| _| _| _| _| _| _| _|  |  | \    ]],
    [[  |/ ___| _| _| _| _| _| _| _| _| _| _| _| ______| \   ]],
    [[  / __| _| _| _| _| _| _| _| _| _| _| _| _| _| ___| \  ]],
    [[ / _| _| _| _| ________________________| _| _| _| _| \ ]],
    [[|------"--------------------------------------"-------|]],
    [[`-----------------------------------------------------']],
}
local nvim_icon_val = {
    [[                               __                ]],
    [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
    [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
    [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    [[                                                 ]],
}


local go_nvim_dashboard = {
    [[                                __                ]],
    [[   __     ___     ___   __  __ /\_\    ___ ___    ]],
    [[ /'_ `\  / __`\ /' _ `\/\ \/\ \\/\ \ /' __` __`\  ]],
    [[/\ \L\ \/\ \L\ \/\ \/\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[\ \____ \ \____/\ \_\ \_\ \___/  \ \_\ \_\ \_\ \_\]],
    [[ \/___L\ \/___/  \/_/\/_/\/__/    \/_/\/_/\/_/\/_/]],
    [[   /\____/                                        ]],
    [[   \_/__/                                         ]],
}

dashboard.section.header.val  = go_nvim_dashboard
dashboard.section.buttons.val = {
    dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
    dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
    dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
    dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
    dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

local function footer()
    -- NOTE: requires the fortune-mod package to work
    local plugins = #vim.tbl_keys(packer_plugins)
    local v = vim.version()
    local datetime = os.date(" %Y-%m-%d   %H:%M:%S")

    local platform = vim.fn.has("win32") == 1 and "" or vim.fn.has("macunix") == 1 and "" or ""

    return string.format(" %d   v%d.%d.%d %s  %s", plugins, v.major, v.minor, v.patch, platform, datetime)
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)
