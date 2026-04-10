local M = {}

local gh = function(repo)
  return "https://github.com/" .. repo
end

local needs_restart = false
local loaded_features = {}
local configured_features = {}
local specs_by_name = {}

local specs = {
  { name = "tokyonight.nvim", src = gh("folke/tokyonight.nvim") },
  { name = "mini.icons", src = gh("echasnovski/mini.icons") },
  { name = "dressing.nvim", src = gh("stevearc/dressing.nvim") },
  { name = "nvim-autopairs", src = gh("windwp/nvim-autopairs") },
  { name = "lualine.nvim", src = gh("nvim-lualine/lualine.nvim") },
  { name = "glow.nvim", src = gh("ellisonleao/glow.nvim") },
  { name = "neoscroll.nvim", src = gh("karb94/neoscroll.nvim") },
  { name = "dashboard-nvim", src = gh("nvimdev/dashboard-nvim") },
  { name = "nvim-tree.lua", src = gh("nvim-tree/nvim-tree.lua") },
  { name = "oil.nvim", src = gh("stevearc/oil.nvim") },
  { name = "which-key.nvim", src = gh("folke/which-key.nvim") },
  { name = "flash.nvim", src = gh("folke/flash.nvim") },
  { name = "gitsigns.nvim", src = gh("lewis6991/gitsigns.nvim") },
  { name = "conform.nvim", src = gh("stevearc/conform.nvim") },
  { name = "mason.nvim", src = gh("williamboman/mason.nvim") },
  { name = "mason-lspconfig.nvim", src = gh("williamboman/mason-lspconfig.nvim") },
  { name = "nvim-lspconfig", src = gh("neovim/nvim-lspconfig") },
  { name = "nvim-cmp", src = gh("hrsh7th/nvim-cmp") },
  { name = "cmp-nvim-lsp", src = gh("hrsh7th/cmp-nvim-lsp") },
  { name = "cmp-buffer", src = gh("hrsh7th/cmp-buffer") },
  { name = "cmp-path", src = gh("hrsh7th/cmp-path") },
  { name = "cmp-cmdline", src = gh("hrsh7th/cmp-cmdline") },
  { name = "nvim-treesitter", src = gh("nvim-treesitter/nvim-treesitter") },
  { name = "nvim-treesitter-context", src = gh("nvim-treesitter/nvim-treesitter-context") },
  { name = "telescope.nvim", src = gh("nvim-telescope/telescope.nvim") },
  { name = "plenary.nvim", src = gh("nvim-lua/plenary.nvim") },
  { name = "telescope-file-browser.nvim", src = gh("nvim-telescope/telescope-file-browser.nvim") },
  { name = "telescope-live-grep-args.nvim", src = gh("nvim-telescope/telescope-live-grep-args.nvim") },
  { name = "telescope-fzf-native.nvim", src = gh("nvim-telescope/telescope-fzf-native.nvim") },
  { name = "nvim-dap", src = gh("mfussenegger/nvim-dap") },
  { name = "mason-nvim-dap.nvim", src = gh("jay-babu/mason-nvim-dap.nvim") },
  { name = "nvim-dap-ui", src = gh("rcarriga/nvim-dap-ui") },
  { name = "nvim-nio", src = gh("nvim-neotest/nvim-nio") },
  { name = "nvim-dap-go", src = gh("leoluz/nvim-dap-go") },
  { name = "nvim-dap-python", src = gh("mfussenegger/nvim-dap-python") },
  { name = "vim-surround", src = gh("tpope/vim-surround") },
  { name = "vim-unimpaired", src = gh("tpope/vim-unimpaired") },
  { name = "vim-fugitive", src = gh("tpope/vim-fugitive") },
  { name = "vim-go", src = gh("fatih/vim-go") },
  { name = "d2-vim", src = gh("terrastruct/d2-vim") },
  { name = "nordtheme", src = gh("nordtheme/vim") },
  { name = "dracula", src = gh("dracula/vim") },
  { name = "copilot.vim", src = gh("github/copilot.vim") },
}

local feature_defs = {
  startup = {
    plugins = {
      "tokyonight.nvim",
      "mini.icons",
      "dressing.nvim",
      "nvim-autopairs",
      "lualine.nvim",
      "neoscroll.nvim",
      "dashboard-nvim",
      "which-key.nvim",
      "flash.nvim",
      "nvim-treesitter",
      "nvim-treesitter-context",
      "vim-surround",
      "vim-unimpaired",
      "vim-fugitive",
      "copilot.vim",
    },
    setup = function()
      require("es.plugins.ui").setup()
      require("es.plugins.which-key").setup()
      require("es.plugins.flash").setup()
      require("es.plugins.treesitter").setup()
    end,
  },
  explorer = {
    plugins = { "nvim-tree.lua", "oil.nvim", "glow.nvim" },
    setup = function()
      require("es.plugins.explorer").setup()
    end,
  },
  telescope = {
    plugins = {
      "plenary.nvim",
      "telescope.nvim",
      "telescope-file-browser.nvim",
      "telescope-live-grep-args.nvim",
      "telescope-fzf-native.nvim",
    },
    setup = function()
      require("es.plugins.telescope").setup()
    end,
  },
  lsp = {
    plugins = {
      "conform.nvim",
      "mason.nvim",
      "mason-lspconfig.nvim",
      "nvim-lspconfig",
      "cmp-nvim-lsp",
    },
    setup = function()
      require("es.plugins.formatting").setup()
      require("es.plugins.lsp").setup()
    end,
  },
  cmp = {
    plugins = {
      "nvim-cmp",
      "cmp-buffer",
      "cmp-path",
      "cmp-cmdline",
    },
    setup = function()
      require("es.plugins.cmp").setup()
    end,
  },
  gitsigns = {
    plugins = { "gitsigns.nvim" },
    setup = function()
      require("es.plugins.gitsigns").setup()
    end,
  },
  dap = {
    plugins = {
      "nvim-dap",
      "mason-nvim-dap.nvim",
      "nvim-nio",
      "nvim-dap-ui",
      "nvim-dap-go",
      "nvim-dap-python",
    },
    setup = function()
      require("es.plugins.dap").setup()
    end,
  },
}

local function safe_setup(label, fn)
  local ok, err = pcall(fn)
  if ok then
    return true
  end

  local missing = type(err) == "string" and (
    err:match("module '.*' not found")
    or err:match("E5113:")
  )

  if missing then
    needs_restart = true
    vim.schedule(function()
      vim.notify(
        ("vim.pack: deferred %s setup until next restart after initial install"):format(label),
        vim.log.levels.WARN
      )
    end)
    return false
  end

  error(err)
end

local function register_specs()
  for _, spec in ipairs(specs) do
    specs_by_name[spec.name] = spec
  end
end

local function load_plugins(names)
  local selected = {}

  for _, name in ipairs(names) do
    local spec = specs_by_name[name]
    if not spec then
      error(("vim.pack: unknown plugin spec %s"):format(name))
    end
    selected[#selected + 1] = spec
  end

  vim.pack.add(selected, {
    confirm = false,
    load = true,
  })
end

local function register_all_for_update()
  vim.pack.add(specs, {
    confirm = false,
    load = false,
  })
end

local function run_after_change(ev)
  local spec = ev.data and ev.data.spec
  local kind = ev.data and ev.data.kind
  if not spec or (kind ~= "install" and kind ~= "update") then
    return
  end

  local hooks = {
    ["telescope-fzf-native.nvim"] = function()
      vim.system({ "make" }, { cwd = ev.data.path }, function(obj)
        if obj.code ~= 0 then
          vim.schedule(function()
            vim.notify("vim.pack: failed to build telescope-fzf-native.nvim", vim.log.levels.WARN)
          end)
        end
      end)
    end,
    ["nvim-treesitter"] = function()
      pcall(vim.cmd, "TSUpdate")
    end,
    ["mason.nvim"] = function()
      pcall(vim.cmd, "MasonUpdate")
    end,
    ["vim-go"] = function()
      pcall(vim.cmd, "GoUpdateBinaries")
    end,
  }

  local hook = hooks[spec.name]
  if hook then
    hook()
  end
end

function M.load(feature)
  local def = feature_defs[feature]
  if not def then
    error(("vim.pack: unknown feature %s"):format(feature))
  end

  if not loaded_features[feature] then
    load_plugins(def.plugins)
    loaded_features[feature] = true
  end

  if not configured_features[feature] and def.setup then
    if safe_setup(feature, def.setup) then
      configured_features[feature] = true
    end
  end
end

vim.api.nvim_create_autocmd("PackChanged", {
  callback = run_after_change,
})

register_specs()
M.load("startup")

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    M.load("lsp")
    M.load("gitsigns")
  end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  once = true,
  callback = function()
    M.load("cmp")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  once = true,
  callback = function()
    load_plugins({ "vim-go" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "d2",
  once = true,
  callback = function()
    load_plugins({ "d2-vim" })
  end,
})

vim.api.nvim_create_user_command("PackUpdate", function()
  register_all_for_update()
  vim.pack.update()
end, { desc = "Update vim.pack-managed plugins" })

vim.api.nvim_create_user_command("PackStatus", function()
  register_all_for_update()
  vim.pack.update(nil, { offline = true })
end, { desc = "Inspect vim.pack-managed plugins" })

if needs_restart then
  vim.schedule(function()
    vim.notify("vim.pack: initial install completed; restart Neovim to finish loading all plugins", vim.log.levels.WARN)
  end)
end

return M
