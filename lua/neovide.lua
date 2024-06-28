local G = vim.g
vim.opt.mouse = 'a'
vim.opt.smoothscroll = true
G.neovide_scroll_animation_length = 0
G.neovide_refresh_rate = 60
G.neovide_touch_drag_timeout = 0
G.neovide_cursor_animation_length = 0
G.neovide_cursor_trail_size = 0
G.neovide_cursor_antialiasing = true
G.neovide_cursor_animate_in_insert_mode = false
G.neovide_cursor_vfx_mode = ''
G.neovide_padding_top = 0
G.neovide_padding_bottom = 0
G.neovide_padding_right = 0
G.neovide_padding_left = 0

G.gui_font_default_size = 19
G.gui_font_size = vim.g.gui_font_default_size
G.gui_font_face = 'Comic Code,CaskaydiaCove Nerd Font'

local set_guifont = function()
  vim.opt.guifont = string.format('%s:h%s', vim.g.gui_font_face, vim.g.gui_font_size)
end

local resize_guifont = function(delta)
  G.gui_font_size = G.gui_font_size + delta
  set_guifont()
end

local reset_guifont = function()
  G.gui_font_size = G.gui_font_default_size
  set_guifont()
end

-- Call function on startup to set default value
reset_guifont()

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<C-+>', function()
  resize_guifont(1)
end, opts)
vim.keymap.set('n', '<C-->', function()
  resize_guifont(-1)
end, opts)
vim.keymap.set('n', '<C-0>', function()
  reset_guifont()
end, opts)
