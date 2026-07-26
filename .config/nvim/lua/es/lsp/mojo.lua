-- lspconfig ships mojo with `.git` as its only root marker, which resolves the
-- workspace to the repository rather than the project when a repo holds more
-- than one. uv-managed Mojo projects are anchored by pyproject.toml.
return {
  root_markers = { "pyproject.toml", "mojoproject.toml", ".git" },
}
