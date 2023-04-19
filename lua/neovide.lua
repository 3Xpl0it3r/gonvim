if vim.fn.exists("g:neovide") then
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	-- vim.g.transparency = 1.0
	-- vim.g.neovide_transparency = 1.0
	-- Refresh Rate
	vim.g.neovide_refresh_rate = 90
	vim.g.neovide_refresh_rate_idle = 5
	vim.g.neovide_no_idle = false
	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_confirm_quit = true
	vim.g.neovide_fullscreen = false
	vim.g.neovide_input_use_logo = false
	vim.g.neovide_profiler = false
	vim.g.neovide_cursor_antialiasing = false
	vim.g.neovide_cursor_unfocused_outline_width = 0.125
	-- vim.g.neovide_cursor_vfx_particle_density = 7.0
	-- vim.g.neovide_cursor_vfx_particle_speed = 5.0
	-- vim.g.neovide_cursor_vfx_particle_phase = 1.0
	-- vim.g.neovide_cursor_vfx_particle_curl = 1.0
	vim.g.neovide_cursor_vfx_particle_phase = 2.0
	vim.g.neovide_cursor_vfx_particle_curl = 0.5
	-- change vim cursor from block to underline
	vim.cmd([[
    " g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
        " let g:neovide_background_color = '#0f1117'.printf('%x', float2nr(255 * g:transparency))
    ]])



end
