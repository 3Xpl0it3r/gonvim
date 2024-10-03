-- vim.cmd("colorscheme catppuccin-mocha")
-- vim.cmd("colorscheme flexoki-dark")
vim.cmd("colorscheme tokyonight")
-- vim.cmd("colorscheme catppuccin-mocha")

vim.cmd([[
    set list                 " hide non-printing characters
    set listchars=             " clear defaults
    set listchars+=tab:\ \ "    " show a small arrow for a tab
    set listchars+=nbsp:␣      " show a small open box for non-breaking spaces
    " set listchars+=precedes:«  " show a small double-chevron for text to the left
    " set listchars+=extends:»   " show a small double-chevron for text to the right
    " set listchars+=eol:⏎        " show newline symbol at the end of a line
    set showbreak=↪
]])


------------------------------------------------
----      AutoCommands
------------------------------------------------

vim.cmd([[
  augroup _fold_bug_solution  " https://github.com/nvim-telescope/telescope.nvim/issues/559
    autocmd!
    autocmd BufRead * autocmd BufWinEnter * ++once normal! zx
  augroup end
]])

vim.cmd([[
    let &t_SI.= "<Esc>[6 q"
    let &t_SR.= "<Esc>[4 q"
    let &t_EI.= "<Esc>[3 q"
]])

vim.cmd([[
    runtime! plugin/rplugin.vim
    silent! UpdateRemotePlugins
]])

-- keep cursor on middle of screen
-- vim.cmd([[
--     augroup KeepCentered
--       autocmd!
--       autocmd CursorMoved * normal zz
--     augroup END
-- ]])


