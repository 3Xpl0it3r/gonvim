if vim.fn.exists("g:neovide") then
	vim.cmd([[ 
    " https://neovide.dev/configuration.html
        let g:neovide_floating_blur_amount_x = 2.0
        let g:neovide_floating_blur_amount_y = 2.0
        " set transparency
        let g:neovide_transparency = 1
        " set set the refresh rate of the app
        let g:neovide_refresh_rate = 120
        "  set ide references
        let g:neovide_refresh_rate_idle = 5
        let g:neovide_no_idle = v:true


        "Available since 0.10

        let g:neovide_confirm_quit = v:true
        let g:neovide_fullscreen = v:false

        let g:neovide_input_use_logo = v:true  " v:true on macOS

        let g:neovide_cursor_vfx_mode = "railgun"

    ]])
end
