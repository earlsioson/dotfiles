if not pcall(require, "mason") then
  return
end

require("mason").setup()
require("mason-lspconfig").setup()
