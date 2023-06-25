local has_luasnip, luasnip = pcall(require, "luasnip")
if not has_luasnip then
  return
end

local has_from_vscode, from_vscode = pcall(require, "luasnip.loaders.from_vscode")
if not has_from_vscode then
  return
end

luasnip.config.set_config({
  region_check_events = 'InsertEnter',
  delete_check_events = 'InsertLeave'
})

from_vscode.lazy_load({ paths = { "./snippets" } })
