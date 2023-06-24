require("bufferline").setup({
  options = {
    themable = true,
    offsets = {
      {
        filetype = "NvimTree",
        highlight = "NvimTreeNormal",
      },
    },
  },
})

--Aerial setup for file ouline
-- require("aerial").setup {}

--[[ -- Mini library modules setup
require("mini.files").setup {
  mappings = {
    close = "q",
    go_in = "<Left>",
    go_in_plus = "L",
    go_out = "<Right>",
    go_out_plus = "H",
    reset = "<BS>",
    show_help = "g?",
    synchronize = "=",
    trim_left = "<",
    trim_right = ">",
  },
  windows = {
    max_number = math.huge,
    preview = true,
    width_focus = 50,
    width_nofocus = 15,
  },
} ]]

-- Mini textobjects
require("mini.ai").setup({
  custom_textobjects = {
    Z = function(ai_type)
      local n_lines = vim.fn.line("$")
      local start_line, end_line = 1, n_lines
      if ai_type == "i" then
        -- Skip first and last blank lines for `i` textobject
        local first_nonblank, last_nonblank = vim.fn.nextnonblank(1), vim.fn.prevnonblank(n_lines)
        start_line = first_nonblank == 0 and 1 or first_nonblank
        end_line = last_nonblank == 0 and n_lines or last_nonblank
      end
      local to_col = math.max(vim.fn.getline(end_line):len(), 1)
      return {
        from = {
          line = start_line,
          col = 1,
        },
        to = {
          line = end_line,
          col = to_col,
        },
      }
    end,
  },
})
-- Mini splitjoins arguments no TS required
require("mini.splitjoin").setup({})
-- Mini bracketed textobjects
require("mini.bracketed").setup({})
-- Mini jump extension to FfTf
require("mini.jump").setup({})

-- require("mini.comment").setup {
--   mappings = {
--     comment_line = "<leader>/",
--   },
-- }

-- clangd setup
-- require("clangd_extensions").prepare()
-- require("clangd_extensions").setup()

--rust tools
-- require("rust-tools").setup {}
