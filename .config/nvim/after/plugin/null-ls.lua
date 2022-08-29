local has_null_ls, null_ls = pcall(require, "null-ls")
if not has_null_ls then
  return
end

null_ls.setup({
  sources = {
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.completion.luasnip,
    null_ls.builtins.completion.spell,
    null_ls.builtins.diagnostics.buf,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.diagnostics.luacheck,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.diagnostics.protoc_gen_lint,
    null_ls.builtins.diagnostics.pylint,
    null_ls.builtins.diagnostics.tidy,
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.buf,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.lua_format,
    null_ls.builtins.formatting.markdownlint,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.sql_formatter,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.taplo,
    null_ls.builtins.formatting.yamlfmt
  }
})
