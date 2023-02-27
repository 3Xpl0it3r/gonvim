-- vim.cmd("colorscheme kanagawa")
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


vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlayhints",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require("lsp-inlayhints").on_attach(client, bufnr)
  end,
})
