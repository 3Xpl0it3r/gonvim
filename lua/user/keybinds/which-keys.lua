local M = {}

M.normal = {
    mode = { "n" },
    { "<leader>~",  "<CMD>noh<CR>",                                                                        desc = "Cancel Highlight",        nowait = true,  remap = false },
    { "<leader>!",  "<cmd>source ~/.config/nvim/init.lua<CR>",                                             desc = "ReloadConfig",            nowait = false, remap = false },
    { "<leader>f",  "<cmd>lua require'telescope.builtin'.find_files()<cr>",                                desc = "FindFile",                nowait = false, remap = false },
    { "<leader>n",  "<cmd>Neotree toggle reveal<CR>",                                                      desc = "DirExploer",              nowait = false, remap = false },
    { "<leader>q",  "<cmd>q!<CR>",                                                                         desc = "Quit",                    nowait = false, remap = false },
    { "<leader>z",  "<cmd>lua require'tsexample'.test()<cr>",                                              desc = "TestTS",                  nowait = false, remap = false },

    -- LLM
    { "<leader>a",  group = "Avata(LLM)",                                                                   nowait = false,                   remap = false },



    -- group Code
    { "<leader>c",  group = "Code",                                                                        nowait = false,                   remap = false },
    { "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>",                                              desc = "CodeAction",              nowait = false, remap = false },
    { "<leader>cr", "<cmd>lua require'sniprun'.run()<cr>",                                                 desc = "SnipRun",                 nowait = false, remap = false },

    -- Group debug
    { "<leader>d",  group = "Debug",                                                                       nowait = false,                   remap = false },

    -- Git
    { "<leader>g",  group = "Git",                                                                         nowait = false,                   remap = false },
    { "<leader>gB", '<cmd>lua require"extensions.git".branch()<CR>',                                  desc = "Git History",             nowait = false, remap = false },
    { "<leader>gR", '<cmd>lua require"gitsigns".reset_buffer()<CR>',                                       desc = "Reset(Buffer)",           nowait = false, remap = false },
    { "<leader>gU", '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',                                 desc = "Reset(Buffer Index)",     nowait = false, remap = false },
    { "<leader>gb", '<cmd>lua require"gitsigns".blame_line{}<CR>',                                         desc = "Blame",                   nowait = false, remap = false },
    { "<leader>gd", '<cmd>lua require"extensions.git".diff()<CR>',                                    desc = "Diff",                    nowait = false, remap = false },
    { "<leader>gl", '<cmd>lua require"extensions.git".history()<CR>',                                 desc = "Git History",             nowait = false, remap = false },
    { "<leader>gp", '<cmd>lua require"gitsigns".preview_hunk()<CR>',                                       desc = "preview(Hunk)",           nowait = false, remap = false },
    { "<leader>gq", '<cmd>lua require"extensions.git".quit()<CR>',                                    desc = "Quit",                    nowait = false, remap = false },
    { "<leader>gr", '<cmd>lua require"gitsigns".reset_hunk()<CR>',                                         desc = "Reset(Hunk)",             nowait = false, remap = false },
    { "<leader>gs", '<cmd>lua require"extensions.git".status()<CR>',                                  desc = "Git status",              nowait = false, remap = false },
    { "<leader>gu", '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>}',                                   desc = "Undo Stage Hunk",         nowait = false, remap = false },


    -- LSP
    { "<leader>l",  group = "Lsp",                                                                         nowait = false,                   remap = false },
    { "<leader>lD", "<cmd>lua require('telescope.builtin').lsp_type_definitions({show_line = false})<cr>", desc = "TypeDefine",              nowait = false, remap = false },
    { "<leader>lc", "<cmd>lua vim.lsp.buf.rename()<CR>",                                                   desc = "Change(Rename)",          nowait = false, remap = false },
    { "<leader>ld", "<cmd>lua require('telescope.builtin').lsp_definitions({show_line=false})<cr>",        desc = "Define",                  nowait = false, remap = false },
    { "<leader>le", "<cmd>lua require('telescope.builtin').diagnostics()<cr>",                             desc = "diagnostics",             nowait = false, remap = false },
    { "<leader>lf", "<cmd>lua vim.lsp.buf.format({async=true})<cr>",                                       desc = "LspFormat",               nowait = false, remap = false },
    { "<leader>lh", "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>",         desc = "Inlay Hints(nvim>=0.10)", nowait = false, remap = false },
    { "<leader>li", "<cmd>lua require('telescope.builtin').lsp_implementations({show_line = false})<cr>",  desc = "Interface",               nowait = false, remap = false },
    { "<leader>lr", "<cmd>lua require('telescope.builtin').lsp_references({show_line = false})<cr>",       desc = "Reference",               nowait = false, remap = false },
    { "<leader>lt", "<cmd>lua require('telescope.builtin').diagnostics()<cr>",                             desc = "Trouble",                 nowait = false, remap = false },



    -- BookMark
    { "<leader>m",  group = "BookMarks",                                                                   nowait = false,                   remap = false },
    { "<leader>ma", "<cmd>lua require('extensions.bookmarks').add()<cr>",                                  desc = "Add BookMarks",           nowait = false, remap = false },
    { "<leader>mc", "<cmd>lua require('extensions.bookmarks').clean_all()<cr>",                            desc = "Clean All",               nowait = false, remap = false },
    { "<leader>ml", "<cmd>lua require('extensions.bookmarks').actions()<cr>",                              desc = "List Bookmarks",          nowait = false, remap = false },


    -- Plugin
    { "<leader>p",  group = "Plugins",                                                                     nowait = false,                   remap = false },
    { "<leader>pC", "<cmd>lua require('lazy').clean()<cr>",                                                desc = "Clean",                   nowait = false, remap = false },
    { "<leader>pc", "<cmd>lua require('lazy').check()<cr>",                                                desc = "Check",                   nowait = false, remap = false },
    { "<leader>ph", "<cmd>lua require('lazy').health()<cr>",                                               desc = "Health",                  nowait = false, remap = false },
    { "<leader>pi", "<cmd>lua require('lazy').install()<cr>",                                              desc = "Install",                 nowait = false, remap = false },
    { "<leader>ps", "<cmd>lua require('lazy').sync()<cr>",                                                 desc = "Sync",                    nowait = false, remap = false },
    { "<leader>pu", "<cmd>lua require('lazy').update()<cr>",                                               desc = "Update",                  nowait = false, remap = false },


    -- Search
    { "<leader>s",  group = "Search",                                                                      nowait = false,                   remap = false },
    { "<leader>sb", "<cmd>lua require('telescope.builtin').buffers()<cr>",                                 desc = "Buffer",                  nowait = false, remap = false },
    { "<leader>sf", "<cmd>lua require('telescope.builtin').find_files()<cr>",                              desc = "FindFile",                nowait = false, remap = false },
    { "<leader>sg", "<cmd>lua require('telescope.builtin').live_grep()<cr>",                               desc = "FindText",                nowait = false, remap = false },
    { "<leader>sp", "<cmd>lua require('telescope.builtin').live_grep()<cr>",                               desc = "Project",                 nowait = false, remap = false },
    { "<leader>st", "<cmd>lua require('telescope.builtin').treesitter()<cr>",                              desc = "Treesitter",              nowait = false, remap = false },



    -- Unit test
    { "<leader>t",  group = "UintTest",                                                                    nowait = false,                   remap = false },
    { "<leader>tR", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>',                         desc = "Run",                     nowait = false, remap = false },
    { "<leader>td", '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>',                         desc = "Debug neartest",          nowait = false, remap = false },
    { "<leader>tr", '<cmd>lua require("neotest").run.run()<CR>',                                           desc = "Run",                     nowait = false, remap = false },
    { "<leader>ts", '<cmd>lua require("neotest").summary.toggle()<CR>',                                    desc = "Summary",                 nowait = false, remap = false },


    -- Windows
    { "<leader>w",  group = "Windows",                                                                     nowait = false,                   remap = false },
    { "<leader>wg", "<cmd>lua toggleterm_wrapper_lazygit()<cr>",                                           desc = "lazygit",                 nowait = false, remap = false },
    { "<leader>wn", "<cmd>ToggleTerm <cr>",                                                                desc = "terminal",                nowait = false, remap = false },
    { "<leader>wr", "<cmd>lua toggleterm_wrapper_ranger()<cr>",                                            desc = "ranger",                  nowait = false, remap = false },


}


M.visual = {
    mode = { "v" },
    { "<leader>c",  group = "Code",                                                                    nowait = false,       remap = false },
    { "<leader>cr", "<cmd>lua require'sniprun'.run('v')<cr>",                                          desc = "sniprun",     nowait = false, remap = false },

    { "<leader>g",  group = "Git",                                                                     nowait = false,       remap = false },
    { "<leader>gr", '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>', desc = "Reset(Hunk)", nowait = false, remap = false },
    { "<leader>gs", '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>', desc = "Stage(Hunk)", nowait = false, remap = false },
    { "<leader>q",  "<cmd>q!<CR>",                                                                     desc = "Quit",        nowait = false, remap = false },
}


return M
