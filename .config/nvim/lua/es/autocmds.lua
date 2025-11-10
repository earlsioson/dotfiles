local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("es_general_autocmds", { clear = true })

autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = general,
  command = "checktime",
})

autocmd("VimResized", {
  group = general,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

autocmd("TermOpen", {
  group = general,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

autocmd("BufReadPost", {
  group = general,
  callback = function(args)
    local mark_line = vim.fn.line([['"]], args.buf)
    local total = vim.api.nvim_buf_line_count(args.buf)
    if mark_line > 0 and mark_line <= total then
      pcall(vim.api.nvim_win_set_cursor, 0, { mark_line, 0 })
    end
  end,
})
