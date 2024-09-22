local map = vim.keymap.set
-- map("n", "<leader>lf", "<cmd>silent !context %:r.tex; zathura %:r.pdf & <CR>", { desc = "Fompile" })
-- map("n", "<C-s>", "<cmd>w <CR>| :silent !context %:r.tex; zathura -e %:r.pdf & <CR>", { desc = "Compile" })

local function fompile()
  local file = vim.fn.expand "%"
  local pdf_file = vim.fn.expand "%:r" .. ".pdf"
  print("Compiling " .. file .. " to " .. pdf_file)
  io.popen("context " .. file .. " >/dev/null ; zathura " .. pdf_file .. " &")
end

local function scompile()
  vim.cmd "silent w"
  local file = tostring(vim.fn.expand "%")
  local pdf_file = tostring(vim.fn.expand "%:r" .. ".pdf")
  io.popen("context " .. file .. " >/dev/null ; zathura --reparent " .. pdf_file .. " 2>/dev/null &")
  print(
    "Written "
    .. file
    .. " @ "
    .. os.date "%H:%M:%S"
    .. " and executed: "
    .. "context "
    .. file
    .. " >/dev/null ; zathura -e "
    .. pdf_file
    .. " 2>/dev/null &"
  )
end

local function count_processes()
  local zathura_handle = io.popen "pgrep -c zathura"
  if zathura_handle == nil then
    print "Handle is nil"
    return
  end
  local zathura_count = tonumber(zathura_handle:read "*a")
  zathura_handle:close()

  local context_handle = io.popen "pgrep -c context"
  if context_handle == nil then
    print "Handle is nil"
    return
  end
  local context_count = tonumber(context_handle:read "*a")
  context_handle:close()

  print("Zathura instances: " .. zathura_count .. " Context instances: " .. context_count)
end

map("n", "<leader>ll", fompile, { silent = true, desc = "Fompile" })
map("n", "<C-m>", scompile, { silent = true, desc = "Scompile" })
map("n", "<leader>lc", count_processes, { desc = "Count processes" })
