require("telescope").setup({
  defaults = {
    file_previewer = require("telescope.previewers").cat_new,
    grep_previewer = require("telescope.previewers").vimgrep_new,
    qflist_previewer = require("telescope.previewers").qflist.new,

    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    preview = {
      treesitter = false,
      filesize_limit = 1,
      timeout = 250,
      -- truncate for preview
      filesize_hook = function(filepath, bufnr, opts)
        local path = require("plenary.path"):new(filepath)
        -- opts exposes winid
        local height = vim.api.nvim_win_get_height(opts.winid)
        local lines = vim.split(path:head(height), "[\r]?\n")
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      end,
    },
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
  },
  mappings = {
    n = { ["q"] = require("telescope.actions").close },
  },
  pickers = {
    diagnostics = {
      path_display = "hidden",
    },
  },
  path_display = { "truncate" },
  color_devicons = true,
  set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
  extensions = {
    ["zf-native"] = {
      file = {
        enable = true,
        highlight_results = true,
        match_filename = true,
      },
      generic = {
        enable = true,
        highlight_results = true,
        match_filename = false,
      },
    },
  },
})

require("telescope").load_extension("zf-native")
