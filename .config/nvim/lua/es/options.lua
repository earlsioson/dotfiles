local opt = vim.opt

opt.diffopt:append({ "linematch:50" })

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = vim.fn.expand("~/dev/repos/dotfiles/.venv/bin/python")

if vim.env.TMUX then
  vim.g.clipboard = {
    name = "tmux",
    copy = {
      ["+"] = { "tmux", "load-buffer", "-w", "-" },
      ["*"] = { "tmux", "load-buffer", "-w", "-" },
    },
    paste = {
      ["+"] = { "bash", "-c", "tmux refresh-client -l && sleep 0.2 && tmux save-buffer -" },
      ["*"] = { "bash", "-c", "tmux refresh-client -l && sleep 0.2 && tmux save-buffer -" },
    },
    cache_enabled = false,
  }
end
