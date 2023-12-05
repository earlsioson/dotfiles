local has_auto_session, auto_session = pcall(require, "auto-session")
if not has_auto_session then
  return
end

auto_session.setup {
  log_level = "error",
  auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/", "~/dev/e2g/repos" },
  session_lens = {
    load_on_setup = true,
  },
}
